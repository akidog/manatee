module ActionDispatch::Journey
  module Nodes
    class Node
      def compile_hash
        JavascriptRenderer::Rails::HashVisitor.new.accept self
      end
    end
  end
end

# This is required to Rails for using app directory
module JavascriptRenderer
  class Engine < ::Rails::Engine
  end

  def self.subscribe_on_rails(controller = ApplicationController)
    controller.prepend_view_path JavascriptRenderer::Rails::Resolver.new(JavascriptRenderer.views_asset)
    ActionView::Template.register_template_handler :'jst', JavascriptRenderer::Rails::Handler.instance
    JavascriptRenderer::Sprockets::JshProcessor.subscribe ::Rails.application.assets
  end
end
