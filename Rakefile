require 'bundler/gem_tasks'

task :test do
  Dir.glob('test/{helpers}/**/*_test.rb').each do |file|
    load file
  end
end
