require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name        = "mongo_mapper_sluggable"
    gem.summary     = "Automatic slugged key MongoMapper"
    gem.description = "Allows you to declare a key as a sluggable attribute in MongoMapper"
    gem.authors     = ["Scotty Weeks"]
    gem.email       = "scott.weeks@gmail.com"
    gem.files       = Dir["lib/**/*.rb"]
    
    gem.add_development_dependency "shoulda"
    gem.add_development_dependency "mocha"
    gem.add_dependency "mongo_mapper"
    gem.add_dependency "actionpack"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end
