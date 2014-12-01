load File.expand_path('../../lib/javascript_renderer.rb', __FILE__)

require 'pry'
require 'nokogiri'
require 'test/unit'

Dir.glob(File.expand_path('../support/**/*.rb', __FILE__)) do |file|
  load file
end

JavascriptRenderer.config do |config|
  environment = Sprockets::Environment.new
  environment.append_path File.expand_path('../example',                   __FILE__)
  environment.append_path File.expand_path('../../app/assets/javascripts', __FILE__)
  environment.append_path File.join(Gem.loaded_specs['i18n-js'].full_gem_path, 'app/assets/javascripts')

  config.assets        = environment
  config.views_asset   = 'renderer'
  config.assets_path   = '/'
  config.full_domain   = 'http://www.example.com'
  config.assets_domain = 'http://www.example.com'
end
