# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'manatee/version'

Gem::Specification.new do |spec|
  spec.name          = 'manatee'
  spec.version       = Manatee::VERSION
  spec.summary       = %q{Javascript Template Render [for Rails]?}
  spec.description   = %q{Renders javascript templates with ease on client and server sides}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.authors       = ['Dalton Pinto', 'Felipe JAPM']
  spec.email         = ['dalton@akidog.com.br', 'felipe@akidog.com.br']

  spec.files         = Dir['{app,bin,lib,test,spec}/**/*'] + ['manatee.gemspec', 'LICENSE.txt', 'Rakefile', 'Gemfile', 'README.mdown']
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.executables   = spec.files.grep(%r{^bin/}).map{ |f| File.basename(f) }

  spec.require_paths = ['lib']

  spec.add_dependency 'i18n-js'

  spec.add_dependency 'execjs'
  spec.add_dependency 'sprockets'
  spec.add_dependency 'coffee-script'

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'nokogiri'
end
