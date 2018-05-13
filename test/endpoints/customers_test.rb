require_relative './../test_helper'

describe "GET /customers" do
  it "renders all customers" do
    get '/customers'
    assert_equal 200, last_response.status
    assert_equal JSON.parse(Customer.all.to_json), JSON.parse(last_response.body)
  end
end

describe "GET /customers/:id" do
  it "renders the selected customer" do
    get '/customers/1'
    assert_equal 200, last_response.status
    assert_equal JSON.parse(Customer.find(1).to_json), JSON.parse(last_response.body)
  end
end

describe "POST /customers" do
  describe "with valid params" do
    it "creates a new customer" do
      post '/customers', fed_id: 777, cust_type_cd: "I"
      assert_equal 201, last_response.status
      assert_equal JSON.parse(Customer.last.to_json), JSON.parse(last_response.body)
    end
  end

  describe "with invalid params" do
    it "renders an error message" do
      post '/customers', cust_type_cd: "Individual"
      assert_equal 400, last_response.status
      assert_equal JSON.parse({"errors"=>["Fed id can't be blank", "Cust type cd is not included in the list"]}.to_json), JSON.parse(last_response.body)
    end
  end
end
