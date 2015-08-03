require 'sinatra'
require 'sinatra/activerecord'
require './lib/bank'

class Bank < Sinatra::Application

  before do
    content_type 'application/json'
    response['Access-Control-Allow-Origin'] = '*'
  end

  get '/accounts' do
    json Account.all
  end

  get '/accounts/:id' do
    json Account.find(params[:id])
  end

  get '/customers' do
    json Customer.all
  end

  get '/customers/:id' do
    json Customer.find(params[:id])
  end

  post '/customers' do
    customer = Customer.new(params)
    if customer.save
      status 201
      json customer
    else
      status 400
      json({ errors: customer.errors.full_messages })
    end
  end

  get '/employees' do
    json Employee.all
  end

  helpers do
    def json(obj)
      obj.to_json
    end
  end
end
