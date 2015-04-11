module Manatee
  module Rails
    class Handler < Manatee::Handler

      def self.default_format
        Mime::HTML
      end

      def call(template)
        locals = (template.locals || []).map{ |key| "#{key}: #{key}"}.join ', '
        locals = 'Hash.new' if locals.blank?
        identifier = template.identifier
        <<-EOS
          _template_params = self.assigns.except('marked_for_same_origin_verification').merge(csrf_token: form_authenticity_token).merge(#{locals})
          Manatee::Handler.instance.eval_template #{ identifier.inspect }, _template_params
        EOS
      end

    end
  end
end
