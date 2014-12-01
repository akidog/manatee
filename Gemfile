source 'https://rubygems.org'

# Specify your gem's dependencies in javascript_renderer.gemspec
gemspec

gem 'i18n-js', github: 'fnando/i18n-js'

platform :ruby do
  gem 'therubyracer'
end

platform :jruby do
  gem 'therubyrhyno'
end

group :development, :test do
  gem 'pry'
end
