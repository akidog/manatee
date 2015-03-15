load File.expand_path('../../lib/manatee.rb', __FILE__)

require 'pry'
require 'nokogiri'
require 'test/unit'

Dir.glob(File.expand_path('../support/**/*.rb', __FILE__)) do |file|
  load file
end

Manatee.config do |config|
  config.assets        = Manatee::ViewTest.sprockets_environment
  config.views_asset   = 'renderer'
  config.assets_path   = '/'
  config.full_domain   = 'http://www.example.com'
  config.assets_domain = 'http://www.example.com'
end
