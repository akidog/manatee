module Manatee
  module Rails
    module Helper
      def csrf_meta_tags
        if protect_against_forgery?
          (super + content_tag(:script, "this.Renderer || (this.Renderer = {}); Renderer.csrfToken = #{form_authenticity_token.inspect};".html_safe))
        end
      end
    end
  end
end
