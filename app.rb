require 'sinatra'
require 'sinatra/activerecord'
require 'grape'
require 'grape-swagger'

class Customer < ActiveRecord::Base
  self.table_name = 'customer'

  validates_presence_of :fed_id
end

module Bank
  class API < Grape::API
    version 'v1'
    format :json
    prefix 'api'

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
