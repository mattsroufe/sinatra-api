require 'sinatra'
require 'sinatra/activerecord'
require 'grape'
require 'grape-swagger'

class Customer < ActiveRecord::Base
  self.table_name = 'customer'
end

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
  end

  add_swagger_documentation api_version: 'v1'
end

class Web < Sinatra::Base

  get "/apidocs" do
    File.read(File.join('public', 'index.html'))
  end
end
