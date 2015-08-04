require 'sinatra'
require 'sinatra/activerecord'
require 'byebug' unless ENV['RACK_ENV'] == 'production'
require './lib/bank'

class Bank < Sinatra::Application

  before do
    content_type 'application/json'
    response['Access-Control-Allow-Origin'] = '*'
  end

  get '/accounts' do
    json({ accounts: Account.all.include_customer_and_product_type })
  end

  get '/accounts/:id' do
    json Account.find(params[:id]).as_json(root: true)
  end

  get '/branches/:id/accounts' do
    branch = Branch.where(branch_id: params[:id]).include_accounts.first
    res = branch.as_json(root: true)
    res['branch'].merge!(accounts: branch.accounts)
    json res
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
