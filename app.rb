require 'rubygems'
require 'securerandom'
require 'bundler/setup'
require 'sinatra/base'
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

  # get '/customers' do
  #   json Customer.all
  # end

  # post '/customers' do
  #   customer = Customer.new(params)
  #   if customer.save
  #     status 201
  #     json customer
  #   else
  #     status 400
  #     json({ errors: customer.errors.full_messages })
  #   end
  # end

  # get '/employees' do
  #   json Employee.all
  # end

  run! if __FILE__ == $0
end
