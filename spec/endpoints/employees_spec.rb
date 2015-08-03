require_relative './../spec_helper'

describe "GET /employees" do
  it "renders all employees" do
    get '/employees'
    assert_equal 200, last_response.status
    assert_equal JSON.parse(Employee.all.to_json), JSON.parse(last_response.body)
  end
end
