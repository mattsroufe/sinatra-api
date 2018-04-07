require_relative './../test_helper'

describe "GET /accounts" do
  it "renders all accounts" do
    get '/accounts'
    assert_equal 200, last_response.status
    assert_equal JSON.parse(Account.all.to_json), JSON.parse(last_response.body)
  end
end

describe "GET /accounts/:id" do
  it "renders the selected account" do
    get '/accounts/1'
    assert_equal 200, last_response.status
    assert_equal JSON.parse(Account.find(1).to_json), JSON.parse(last_response.body)
  end
end
