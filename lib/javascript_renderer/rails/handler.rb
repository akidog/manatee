module JavascriptRenderer
  module Rails
    class Handler < JavascriptRenderer::Handler

      def self.default_format
        Mime::HTML
      end

      def call(template)
        identifier = template.identifier
        "JavascriptRenderer::Handler.instance.eval_template #{ identifier.inspect }, self.assigns.except('marked_for_same_origin_verification')"
      end

    end
  end
end

# ActionView::Template.register_template_handler :'jst', JavascriptRenderer::Rails::Handler.instance
