require_relative './../test_helper'

describe "GET /employees" do
  it "renders all employees" do
    current_user = User.find_by!(username: 'test')
    movies = EmployeesQuery.for_user(current_user)
    serializer_klass = EmployeeSerializer.for_user(current_user)
    last_response_body = serializer_klass.new(movies).serialized_json

    get '/employees', nil, { "HTTP_TOKEN" => current_user.username }
    assert_equal 200, last_response.status
    assert_equal last_response_body, last_response.body
  end
end
