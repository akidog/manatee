module Manatee
  module Sprockets
    class JshProcessor
      def self.call(input)
        instance.call(input)
      end

      def initialize(options = {})
        @namespace = options[:namespace] || self.class.default_namespace
      end

      def call(input)
        data = input[:data].gsub(/$(.)/m, "\\1  ").strip
        key  = input[:name]
        "( function(helper, alias){ #{data}; } ).call(#{@namespace}, #{@namespace}.helper, #{@namespace}.alias);"
      end

      def self.instance
        @instance ||= new
      end

      def self.default_namespace
        'this.Renderer'
      end

      def self.subscribe(environment)
        environment.register_engine '.jsh', Manatee::Sprockets::JshProcessor, mime_type: 'application/javascript'
      end
    end
  end
end
