require_relative './../test_helper'

describe "GET /employees" do
  it "renders all employees" do
    get '/employees', nil, { 'HTTP_TOKEN' => 'test' }
    assert_equal 200, last_response.status
    last_response_body = JSON.dump({
      data: [
        {
          id: '1',
          type: 'employee',
          attributes: {
            first_name: 'Test',
            last_name: 'Employee'
          }
        }
      ]
    })
    assert_equal last_response_body, last_response.body
  end
end
