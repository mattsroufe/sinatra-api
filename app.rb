require 'sinatra/activerecord'
require './lib/bank'

class Bank < Sinatra::Base

  before do
    content_type 'application/json'
    response['Access-Control-Allow-Origin'] = '*'
  end

  get '/accounts' do
    Account.all.to_json
  end

  get '/accounts/:id' do
    Account.find(params[:id]).to_json
  end

  get '/customers' do
    Customer.all.to_json
  end

  get '/customers/:id' do
    Customer.find(params[:id]).to_json
  end

  post '/customers' do
    customer = Customer.new(params)
    if customer.save
      status 201
      customer.to_json
    else
      status 400
      { errors: customer.errors.full_messages }.to_json
    end
  end

  get '/employees' do
    Employee.all.to_json
  end
end
