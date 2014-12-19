module JavascriptRenderer
  class Config
    def self.context
      domain = {
        app:        JavascriptRenderer.full_domain,
        asset:      JavascriptRenderer.assets_domain,
        font:       JavascriptRenderer.fonts_domain,
        audio:      JavascriptRenderer.audios_domain,
        video:      JavascriptRenderer.videos_domain,
        image:      JavascriptRenderer.images_domain,
        javascript: JavascriptRenderer.javascript_domain,
        stylesheet: JavascriptRenderer.stylesheet_domain
      }

      default_path = {
        asset:      JavascriptRenderer.assets_path,
        font:       JavascriptRenderer.fonts_path,
        audio:      JavascriptRenderer.audios_path,
        video:      JavascriptRenderer.videos_path,
        image:      JavascriptRenderer.images_path,
        javascript: JavascriptRenderer.javascript_path,
        stylesheet: JavascriptRenderer.stylesheet_path
      }

      force_asset_domain = JavascriptRenderer.force_assets_domain || JavascriptRenderer.full_domain != JavascriptRenderer.assets_domain

      {
        domain:                        domain,
        forceDomain:                   JavascriptRenderer.force_domain,
        defaultPath:                   default_path,
        defaultFormat:                 JavascriptRenderer.default_format,
        forceAssetDomain:              force_asset_domain,
        protectFromForgery:            JavascriptRenderer.protect_from_forgery,
        requestForgeryProtectionToken: JavascriptRenderer.request_forgery_protection_token
      }
    end

    def method_missing(method, *args, &block)
      str_method = method.to_s
      if str_method[-1] == '=' && JavascriptRenderer.methods(false).include?(str_method[0..-2].to_sym)
        if block_given?
          JavascriptRenderer.default_config str_method[0..-2].to_sym, &block
        else
          JavascriptRenderer.instance_variable_set :"@#{str_method[0..-2]}", args.first
        end
      else
        super method, *args, &block
      end
    end
  end
end
