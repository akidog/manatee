module ActionDispatch::Journey
  module Nodes
    class Node
      def compile_hash
        JavascriptRenderer::Rails::HashVisitor.new.accept self
      end
    end
  end
end

# This is required to Rails for usign app directory
module JavascriptRenderer
  class Engine < ::Rails::Engine
  end
end
