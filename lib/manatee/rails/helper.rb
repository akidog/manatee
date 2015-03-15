module Manatee
  module Rails
    module Helper
      def csrf_meta_tags
        (super + content_tag(:script, "Renderer.csrfToken = #{form_authenticity_token.inspect};".html_safe))
      end
    end
  end
end
