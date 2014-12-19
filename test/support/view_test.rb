module JavascriptRenderer
  class ViewTest < Test::Unit::TestCase

    CSRF_TOKEN = "gYGgKHmGVZdc56rk5atNpQed2Vntd16L+LVxcBsrEEU="

    protected
    def assert_template(expected, template_identifier, *params)
      assert_equal template_handler.eval_template(template_identifier, params), expected
    end

    def assert_js_helper(expected, helper_name, js_params)
      assert_equal expected, js_helper_call(helper_name, js_params)
    end

    def assert_dom_js_helper(expected, helper_name, js_params)
      assert_equal DomAssertion.parse(expected), DomAssertion.parse( js_helper_call(helper_name, js_params) )
    end

    def assert_helper(expected, helper_name, *attributes, &block)
      assert_equal helper_call(helper_name, *attributes, &block), expected
    end

    def assert_dom_helper(expected, helper_name, *attributes, &block)
      assert_equal DomAssertion.parse( helper_call(helper_name, *attributes, &block) ), DomAssertion.parse(expected)
    end

    def js_helper_call(helper_name, js_params)
      javascript_call "#{JavascriptRenderer.helper_namespace}[#{helper_name.to_s.inspect}](#{js_params})"
    end

    def helper_call(helper_name, *attributes, &block)
      helper_function = "#{JavascriptRenderer.helper_namespace}[#{helper_name.to_s.inspect}]"
      if block_given?
        attributes << block
      end
      template_handler.context.call helper_function, *attributes
    end

    def assert_javascript(expected, javascript_code)
      assert_equal javascript_call(javascript_code), expected
    end

    def assert_dom_javascript(expected, javascript_code)
      assert_equal DomAssertion.parse(javascript_call(javascript_code)), DomAssertion.parse(expected)
    end

    def javascript_call(javascript_code)
      template_handler.eval javascript_code
    end

    def template_handler
      JavascriptRenderer::Handler.instance
    end

    def reset_renderer(&block)
      params = javascript_handler_params
      JavascriptRenderer.config &block
      changed_params = javascript_handler_params
      unless params == changed_params
        JavascriptRenderer.config do |config|
          environment = ::Sprockets::Environment.new
          environment.append_path File.expand_path('../../example',                   __FILE__)
          environment.append_path File.expand_path('../../../app/assets/javascripts', __FILE__)
          environment.append_path File.join(Gem.loaded_specs['i18n-js'].full_gem_path, 'app/assets/javascripts')

          # Done this way to handle differences between sprockets 3.x and 2.x
          JavascriptRenderer::Sprockets::JshProcessor.subscribe environment

          config.assets = environment
        end
        template_handler.reset!
      end
    end

    private
    def javascript_handler_params
      JavascriptRenderer.instance_variables.inject(Hash.new) do |hash, variable|
        hash[variable] = JavascriptRenderer.instance_variable_get(variable) if variable != :@assets
        hash
      end
    end

  end
end
