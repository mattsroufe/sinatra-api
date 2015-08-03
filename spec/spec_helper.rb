ENV['RACK_ENV'] = 'test'

require './app'
require 'minitest/autorun'
require 'rack/test'
require 'byebug'

include Rack::Test::Methods

def app
  Bank
end
