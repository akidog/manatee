source 'https://rubygems.org'

# Specify your gem's dependencies in manatee.gemspec
gemspec

gem 'i18n-js', path: '../i18n-js'

gem 'sprockets', '~> 2'
# gem 'sprockets', '~> 3'

platform :ruby do
  gem 'therubyracer'
end

platform :jruby do
  gem 'therubyrhyno'
end

group :development, :test do
  gem 'eco'
  gem 'pry'
  gem 'test-unit'
end
