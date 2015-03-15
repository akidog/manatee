require 'tilt'

module Manatee
  module Sprockets
    class JshProcessor < Tilt::Template
      attr_reader :namespace

      self.default_mime_type = 'application/javascript'

      def prepare
        @namespace = self.class.default_namespace
      end

      def evaluate(scope, locals, &block)
        "( function(helper, alias){ #{indent(data)}; } ).call(#{namespace}, #{namespace}.helper, #{namespace}.alias);"
      end

      private
      def indent(string)
        string.gsub(/$(.)/m, "\\1  ").strip
      end

      def self.default_namespace
        'this.Renderer'
      end

      def self.subscribe(environment)
        environment.register_engine '.jsh', Manatee::Sprockets::JshProcessor
      end
    end
  end
end
