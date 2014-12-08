source 'https://rubygems.org'

# Specify your gem's dependencies in javascript_renderer.gemspec
gemspec

gem 'i18n-js', path: '../i18n-js'

platform :ruby do
  gem 'therubyracer'
end

platform :jruby do
  gem 'therubyrhyno'
end

group :development, :test do
  gem 'pry'
  gem 'eco'
end
