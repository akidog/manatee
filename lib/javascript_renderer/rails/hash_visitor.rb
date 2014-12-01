module JavascriptRenderer
  module Rails
    class HashVisitor < ActionDispatch::Journey::Visitors::Visitor

      private
      def visit_GROUP(node)
        {
          type:       node.type,
          children: [ visit(node.left) ]
        }
      end

      def terminal(node)
        {
          type:  node.type,
          value: node.left.to_s
        }
      end

      def binary(node)
        {
          type:      node.type,
          children:[ visit(node.left), visit(node.right) ]
        }
      end

      def nary(node)
        {
          type:     node.type,
          children: node.children.map{ |c| visit c }
        }
      end
    end
  end
end
