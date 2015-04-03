require 'rubygems'
require 'bundler/setup'
require 'byebug'
require 'sinatra/base'
require 'sinatra/contrib'
require 'sinatra/activerecord'
require './config/environments'
require './lib/bank'

class Bank < Sinatra::Base
  register Sinatra::Contrib

  configure :production do
    db = URI.parse(ENV['DATABASE_URL'] || 'postgres:///localhost/mydb')

    ActiveRecord::Base.establish_connection(
      :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
      :host     => db.host,
      :username => db.user,
      :password => db.password,
      :database => db.path[1..-1],
      :encoding => 'utf8'
    )
  end

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
          json({ errors: customer.errors.full_messages })
        end
      end

      get '/employees' do
        json Employee.all
      end
    end
  end
  # $0 is the executed file
  # __FILE__ is the current file
  run! if __FILE__ == $0
end
