module Manatee
  module Rails
    class Handler < Manatee::Handler

      def self.default_format
        Mime::HTML
      end

      def call(template)
        identifier = template.identifier
        "Manatee::Handler.instance.eval_template #{ identifier.inspect }, self.assigns.except('marked_for_same_origin_verification')"
      end

    end
  end
end
