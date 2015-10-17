require 'simplecov'
require 'coveralls'

SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start do
  add_filter 'lib/gmail_oauth/gmail_imap_extensions'
end
Coveralls.wear!
require 'minitest/autorun'
require 'minitest/reporters' 
require 'pry'
require 'yaml'
# Use Minitest Reporters
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

def fixture(name)
  File.join(File.join(File.dirname(__FILE__)), 'fixtures', name)
end
