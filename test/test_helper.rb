ENV['RACK_ENV'] = 'test'

require './app'
require 'minitest/autorun'
require 'rack/test'

db_options = YAML.load(File.read('./config/database.yml'))
ActiveRecord::Base.establish_connection(db_options['test'])

include Rack::Test::Methods

User.find_or_create_by!(username: 'test')
User.find_or_create_by!(username: 'admin')
Employee.find_or_create_by!(emp_no: 1, birth_date: '1980-12-06', gender: 'M', hire_date: '2018-06-30', first_name: 'Test', last_name: 'Employee')

def app
  Bank
end
