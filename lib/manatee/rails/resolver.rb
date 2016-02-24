module Manatee
  module Rails
    class Resolver < ActionView::Resolver

      def initialize(jst_template_path)
        super()
        @jst_template_path = jst_template_path
      end

      protected
      def find_templates(name, prefix, partial, details, xfactor=true)
        if details[:handlers].include? :jst
          path    = normalize_path prefix, name, partial
          locales = normalize_array details[:locale]
          formats = normalize_array details[:formats]

          templates = []
          formats.each do |format|
            locales.each do |locale|
              template = find_asset_template path, locale, format
              templates.unshift template if template
            end
          end

          templates
        else
          []
        end
      end

      def find_asset_template(path, locale, format)
        identifier   = [normalize_identifier(path), locale, format].compact.join '.'
        asset_source = Manatee.assets[identifier] || Manatee.assets["#{identifier}.jst"]
        build_template asset_source, path, identifier, format
      end

      def normalize_path(prefix, name, partial)
        name = partial ? "_#{name}" : name
        prefix.present? ? "#{prefix}/#{name}" : name
      end

      def normalize_identifier(path)
        "#{@jst_template_path}/#{path}"
      end

      def normalize_array(array)
        return [nil] if array.blank?
        normalized_array = array.map(&:to_s).uniq.compact
        normalized_array << nil
      end

      def build_template(asset, path, identifier, format)
        return nil unless asset

        source     = asset.source
        identifier = identifier
        handler    = ActionView::Template.registered_template_handler :jst

        format = format ? Mime[format] : Mime::HTML
        details = {
          format:       format,
          updated_at:   asset.mtime,
          virtual_path: path
        }

        ActionView::Template.new source, identifier, handler, details
      end

    end
  end
end
