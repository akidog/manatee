lib = File.expand_path '..', __FILE__
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'json'
require 'execjs'
require 'i18n-js'
require 'sprockets'

require 'manatee/version'

require 'manatee/config'
require 'manatee/handler'
require 'manatee/sprockets'

if defined? Rails
  require 'manatee/rails'
end

module Manatee
  def self.default_config(name, value = nil)
    define_singleton_method(name) do
      variable = :"@#{name}"
      if instance_variable_defined? variable
        instance_variable_get variable
      else
        if block_given?
          instance_variable_set variable, yield(self)
        else
          instance_variable_set variable, value
        end
      end
    end
  end

  default_config :request_forgery_protection_token, :authenticity_token
  default_config :protect_from_forgery, true

  default_config :router_namespace,   'RR'
  default_config :renderer_namespace, 'Renderer'
  default_config :template_namespace, 'JST'

  default_config :views_asset, 'views'
  default_config :full_domain, 'http://localhost:3000'

  default_config(:locale){ |c| I18n.locale }
  default_config(:default_locale){ |c| I18n.default_locale }

  default_config :force_domain,        false
  default_config :force_assets_domain, false

  default_config :default_format, javascript: :js, stylesheet: :css

  default_config :assets_domain, 'http://localhost:3000'

  default_config(:fonts_domain){ |c| c.assets_domain }
  default_config(:audios_domain){ |c| c.assets_domain }
  default_config(:videos_domain){ |c| c.assets_domain }
  default_config(:images_domain){ |c| c.assets_domain }
  default_config(:javascript_domain){ |c| c.assets_domain }
  default_config(:stylesheet_domain){ |c| c.assets_domain }

  default_config :assets_path, '/assets'

  default_config(:fonts_path){ |c| c.assets_path + '/fonts' }
  default_config(:audios_path){ |c| c.assets_path + '/audios' }
  default_config(:videos_path){ |c| c.assets_path + '/videos' }
  default_config(:images_path){ |c| c.assets_path + '/images' }
  default_config(:javascript_path){ |c| c.assets_path + '/javascripts' }
  default_config(:stylesheet_path){ |c| c.assets_path + '/stylesheets' }

  default_config(:digest_extensions){ |c| [] }

  def self.digest_map
    digests = Hash.new
    assets.each_logical_path do |path|
      if digest_extensions.include? File.extname(path)
        digests[path] = assets[path].digest_path
      end
    end
    digests
  end

  def self.assets
    if defined? Rails
      ::Rails.application.assets
    else
      @assets or raise("Manatee's Sprockets environment is not configured, call: Manatee.config{ |c| c.assets = sprockets_environment }")
    end
  end

  def self.config(&block)
    yield Manatee::Config.new
  end

  def self.context
    Manatee::Config.context
  end

end
