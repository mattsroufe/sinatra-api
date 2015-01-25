require 'sinatra'
require 'sinatra/activerecord'
require 'grape'
require 'grape-swagger'

class Customer < ActiveRecord::Base
  self.table_name = 'customer'

  validates_presence_of :fed_id

  has_many :accounts, :foreign_key => :cust_id
end

class Account < ActiveRecord::Base
  self.table_name = "account"

  belongs_to :customer, :foreign_key => :cust_id
end

class Accounts < Grape::API
  resource :accounts do
    desc "Returns all accounts."
    get '/' do
      Account.all
    end

    desc "Returns a single account record."
    params do
      requires :id, type: Integer, desc: "Account id."
    end
    get '/:id' do
      Account.find(params[:id])
    end
  end
end

module Bank
  class API < Grape::API
    version 'v1'
    format :json
    prefix 'api'

    mount Accounts

    resource :customers do
      desc 'Returns all customers.'
      get '/' do
        Customer.all
      end

      desc "Returns a single customer."
      params do
        requires :id, type: Integer, desc: "Customer id."
      end
      get '/:id' do
        Customer.find(params[:id])
      end

      desc "Create a customer."
      params do
        requires :fed_id, type: String, desc: "Customer federal id number."
      end
      post do
        Customer.create!(fed_id: params[:fed_id])
      end

      desc "Returns a single customer's accounts"
      params do
        requires :id, type: Integer, desc: "Customer id."
      end
      get '/:id/accounts' do
        Customer.find(params[:id]).accounts
      end
    end

    add_swagger_documentation api_version: 'v1'
  end

  class Web < Sinatra::Base

    helpers do
      def server_url
        [request.host, request.port].join(':')
      end
    end

    get "/apidocs" do
      erb :index
    end
  end
end
