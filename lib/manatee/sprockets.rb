if Sprockets::VERSION.match /\A3\./
  require 'manatee/sprockets/jsh_processor_3x'
elsif Sprockets::VERSION.match /\A2\./
  require 'manatee/sprockets/jsh_processor_2x'
else
  raise 'Manatee requires Sprockets version 2.x or 3.x'
end
  