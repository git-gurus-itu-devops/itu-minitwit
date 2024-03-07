task :console do
  require 'irb'
  require './myapp'
  ARGV.clear
  IRB.start
end
