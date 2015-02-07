require 'sinatra'
require 'sinatra/activerecord'
require 'grape'
require 'grape-swagger'
require 'grape-entity'
require './lib/bank'

module Bank
  class API < Grape::API
    version 'v1'
    format :json
    prefix 'api'

    mount Accounts
    mount Customers

    add_swagger_documentation api_version: 'v1', hide_format: true
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
