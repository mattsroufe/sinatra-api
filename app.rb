require 'byebug'
require 'sinatra'
require 'sinatra/json'
require 'sinatra/namespace'
require 'sinatra/activerecord'
require './lib/bank'

before do
  response['Access-Control-Allow-Origin'] = '*'
end

namespace '/api' do
  namespace '/v1' do
    get '/accounts' do
      json Account.all
    end

    get '/accounts/:id' do
      json Account.find(params[:id])
    end

    get '/customers' do
      json Customer.all
    end

    post '/customers' do
      customer = Customer.new(params)
      if customer.save
        status 201
        json customer
      else
        status 400
        json({ :errors => customer.errors.full_messages })
      end
    end

    get '/employees' do
      json Employee.all
    end
  end
end
