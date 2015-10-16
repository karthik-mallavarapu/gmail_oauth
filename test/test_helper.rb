require 'minitest/autorun'
require 'minitest/reporters' 
require 'pry'
require 'yaml'
require 'coveralls'

Coveralls.wear!
# Use Minitest Reporters
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

def fixture(name)
  File.join(File.join(File.dirname(__FILE__)), 'fixtures', name)
end
