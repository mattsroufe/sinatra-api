require_relative './../test_helper'

describe "GET /employees" do
  describe "when admin" do
    it "renders all employees with basic attributes" do
      get '/employees', nil, { 'HTTP_TOKEN' => 'admin' }
      assert_equal 200, last_response.status
      last_response_body = JSON.dump({
        data: [
          {
            id: '1',
            type: 'employee',
            attributes: {
              birth_date: '1980-12-06',
              first_name: 'Test',
              gender: 'M',
              hire_date: '2018-06-30',
              last_name: 'Employee',
            }
          }
        ]
      })
      assert_equal last_response_body, last_response.body
    end
  end

  describe "when not admin" do
    it "renders all employees with basic attributes" do
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
end
