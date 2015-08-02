ENV['RACK_ENV'] = 'test'

require './app'
require 'minitest/autorun'
require 'rack/test'

include Rack::Test::Methods

def app
  Bank
end

describe "GET /accounts/:id" do
  it "returns the account" do
    header "Content-Type", "application/json"
    get '/accounts/1', fields: {accounts: ["id", "product_cd"]}
    last_response.body.must_include "{\"type\":\"accounts\",\"id\":1,\"attributes\":{\"id\":1,\"product_cd\":\"CHK\"}}"
  end
end

describe "GET /schema" do
  it "returns the account" do
    header "Content-Type", "application/json"
    get '/schema'
    assert_equal MultiJson.decode(last_response.body), Bank::SCHEMA
  end
end
