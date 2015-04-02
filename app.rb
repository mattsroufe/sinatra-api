require 'byebug'
require 'sinatra'
require 'sinatra/activerecord'
require './lib/bank'

before do
  content_type 'application/json'
  response['Access-Control-Allow-Origin'] = '*'
end

get '/api/v1/accounts' do
  Account.all.to_json
end

get '/api/v1/accounts/:id' do
  Account.find(params[:id]).to_json
end

get '/api/v1/customers' do
  Customer.all.to_json
end

post '/api/v1/customers' do
  Customer.new(params).to_json
end

get '/api/v1/employees' do
  Employee.all.to_json
end
