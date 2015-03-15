module Manatee
  module Rails
    class RoutesCompiler
      def compile
        named_routes.map do |name|
          compile_route name, named_routes[name].path
        end
      end

      protected
      def compile_route(name, path)
        {
          name:           name.to_s,
          helper_name:    helper_name(name),
          names:          path.names,
          optional_names: path.optional_names,
          required_names: path.required_names,
          ast:            path.spec.compile_hash
        }
      end

      def helper_name(name)
        helper_name    = name.to_s.camelize
        helper_name[0] = helper_name[0].downcase
        helper_name
      end

      def named_routes
        ::Rails.application.routes.named_routes
      end

    end
  end
end
