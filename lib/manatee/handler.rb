require 'singleton'

module Manatee
  class Handler
    include Singleton

    def eval_template(identifier, params = {})
      context.call(javascript_template_code(identifier, params), params).html_safe
    end

    def eval(javascript_code)
      context.eval javascript_code
    end

    def context
      check_context
      @context
    end

    def reset!
      @context = nil
    end

    protected
    def javascript_template_code(identifier, params)
      token = params[:csrf_token] ? params[:csrf_token].inspect : false
      <<-EOS
      (function(params){
        #{Manatee.renderer_namespace}.csrfToken = #{token};
        jst_source = #{Manatee.template_namespace}[#{ identifier.inspect }] || #{Manatee.template_namespace}[#{ identifier.match(/\A#{Manatee.views_asset}\//).try(:post_match).try(:inspect) }];
        return jst_source.call(params);
      })
      EOS
    end

    def check_context
      load_context if !instance_variable_get(:@context) || @last_mtime != views_asset.mtime
    end

    def load_context
      asset       = views_asset
      @last_mtime = asset.mtime
      @context    = ExecJS.compile asset.source
    end

    def views_asset
      Manatee.assets[ Manatee.views_asset ]
    end

  end
end
