if Sprockets::VERSION.match /\A3\./
  require 'javascript_renderer/sprockets/jsh_processor_3x'
elsif Sprockets::VERSION.match /\A2\./
  require 'javascript_renderer/sprockets/jsh_processor_2x'
else
  raise 'JavascriptRenderer requires Sprockets version 2.x or 3.x'
end
  