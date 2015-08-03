ENV['RACK_ENV'] = 'test'

require './app'
require 'minitest/autorun'
require 'rack/test'

include Rack::Test::Methods

def app
  Bank
end

describe "GET /accounts/:id" do
  describe "when only certain fields are requested" do
    it "returns the account with only those fields" do
      header "Content-Type", "application/json"
      get '/accounts/1', fields: {accounts: ["id", "product_cd"]}
      last_response.body.must_include "{\"type\":\"accounts\",\"id\":1,\"attributes\":{\"id\":1,\"product_cd\":\"CHK\"}}"
    end
  end

  describe "when fields are specified" do
    it "returns the account and all its fields" do
      header "Content-Type", "application/json"
      get '/accounts/1'
      last_response.body.must_include "{\"type\":\"accounts\",\"id\":1,\"attributes\":{\"id\":1,\"cust_id\":1,\"open_branch_id\":2,\"open_emp_id\":10,\"product_cd\":\"CHK\",\"avail_balance\":1057.75,\"pending_balance\":1057.75,\"status\":\"ACTIVE\"}}"
    end
  end

  describe "when non-allowable fields requested" do
    it "returns an error" do
      header "Content-Type", "application/json"
      get '/accounts/1', foo: "bar"
      last_response.body.must_include "{\"id\":\"bad_request\",\"message\":\"Invalid request.\\n\\n#: failed schema #/definitions/account/links/0/schema: \\\"foo\\\" is not a permitted key.\"}"
    end
  end
end

describe "GET /schema" do
  it "returns the account" do
    header "Content-Type", "application/json"
    get '/schema'
    assert_equal MultiJson.decode(last_response.body), Bank::SCHEMA
  end
end
