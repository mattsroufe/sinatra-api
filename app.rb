require 'rubygems'
require "committee"
require 'multi_json'
require "securerandom"
require 'bundler/setup'
require 'sinatra/base'
require 'sinatra/contrib'
require 'sinatra/activerecord'
require './lib/bank'

class Bank < Sinatra::Base
  SCHEMA = MultiJson.decode(File.read("schema2.json"))

  register Sinatra::Contrib

  set :json_content_type, 'application/vnd.api+json'
  set :json_encoder, Serializer

  use Committee::Middleware::RequestValidation, schema: SCHEMA, strict: true

  def self.current_path
    @@current_path
  end

  def self.current_query_string
    @@current_query_string
  end

  before do
    BASE_URL ||= request.base_url
    @@current_path = request.path
    @@current_query_string = request.query_string
    response['Access-Control-Allow-Origin'] = '*'
  end

  get '/accounts/:id' do
    json Account.find(params[:id])
  end

  # namespace '/api' do
  #   namespace '/v1' do
  #     get '/accounts' do
  #       json Account.all
  #     end

  #     get '/accounts/:id' do
  #       json Account.find(params[:id])
  #     end

  #     get '/customers' do
  #       json Customer.all
  #     end

  #     post '/customers' do
  #       customer = Customer.new(params)
  #       if customer.save
  #         status 201
  #         json customer
  #       else
  #         status 400
  #         json({ errors: customer.errors.full_messages })
  #       end
  #     end

  #     get '/employees' do
  #       json Employee.all
  #     end
  #   end
  # end
  # $0 is the executed file
  # __FILE__ is the current file
  run! if __FILE__ == $0
end
