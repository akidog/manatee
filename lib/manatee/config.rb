module Manatee
  class Config
    def self.context
      domain = {
        app:        Manatee.full_domain,
        asset:      Manatee.assets_domain,
        font:       Manatee.fonts_domain,
        audio:      Manatee.audios_domain,
        video:      Manatee.videos_domain,
        image:      Manatee.images_domain,
        javascript: Manatee.javascript_domain,
        stylesheet: Manatee.stylesheet_domain
      }

      default_path = {
        asset:      Manatee.assets_path,
        font:       Manatee.fonts_path,
        audio:      Manatee.audios_path,
        video:      Manatee.videos_path,
        image:      Manatee.images_path,
        javascript: Manatee.javascript_path,
        stylesheet: Manatee.stylesheet_path
      }

      force_asset_domain = Manatee.force_assets_domain || Manatee.full_domain != Manatee.assets_domain

      {
        domain:                        domain,
        forceDomain:                   Manatee.force_domain,
        defaultPath:                   default_path,
        defaultFormat:                 Manatee.default_format,
        forceAssetDomain:              force_asset_domain,
        protectFromForgery:            Manatee.protect_from_forgery,
        requestForgeryProtectionToken: Manatee.request_forgery_protection_token
      }
    end

    def method_missing(method, *args, &block)
      str_method = method.to_s
      if str_method[-1] == '=' && Manatee.methods(false).include?(str_method[0..-2].to_sym)
        if block_given?
          Manatee.default_config str_method[0..-2].to_sym, &block
        else
          Manatee.instance_variable_set :"@#{str_method[0..-2]}", args.first
        end
      else
        super method, *args, &block
      end
    end
  end
end
