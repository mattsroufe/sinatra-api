ENV['RACK_ENV'] = 'test'

require './app'
require 'minitest/autorun'
require 'rack/test'

include Rack::Test::Methods

def app
  Sinatra::Application
end

describe "customers" do
  it "should successfully return a greeting" do
    get '/api/v1/accounts/1'
    last_response.body.must_include 'Welcome to my page!'
  end
end
