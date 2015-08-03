ENV['RACK_ENV'] = 'test'

require './app'
require 'minitest/autorun'
require 'rack/test'

include Rack::Test::Methods

def app
  Bank
end

describe "GET /accounts" do
  it "returns the account with only those fields" do
    get '/accounts'
    assert_equal JSON.parse(last_response.body), JSON.parse(Account.all.to_json)
  end
end

describe "GET /accounts/:id" do
  it "returns the account with only those fields" do
    get '/accounts/1'
    assert_equal JSON.parse(last_response.body), JSON.parse(Account.find(1).to_json)
  end
end
