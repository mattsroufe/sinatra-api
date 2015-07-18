require 'rubygems'
require "committee"
require 'multi_json'
require "securerandom"
require 'bundler/setup'
require 'sinatra/base'
require 'sinatra/contrib'
require 'sinatra/activerecord'
require './lib/bank'

class String
  def underscore
    self.gsub(/::/, '/').
    gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
    gsub(/([a-z\d])([A-Z])/,'\1_\2').
    tr("-", "_").
    downcase
  end
end

class Bank < Sinatra::Base
  SCHEMA = MultiJson.decode(File.read("schema2.json"))

  register Sinatra::Contrib

  set :json_content_type, 'application/vnd.api+json'
  # set :json_encoder, Serializer

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

  def handle
    # klass = nil
    # id = nil

    # request.path.split('/').tap do |req|
    #   id       = req.delete_at(-1).to_i if req.last.to_i > 0
    #   klass = req.last[0...-1].capitalize.constantize
    # end

    resource, id = params['captures'][0].split('/')
    klass = resource[0...-1].capitalize.constantize

    request.body.rewind
    request_body = MultiJson.decode request.body.read

# this works so far
# http://localhost:5000/api/v1/accounts/1?include=customer,product.product_type&fields[product_types]=name&fields[products]=product_type_cd&fields[accounts]=product_cd,open_date&fields[customers]=city,address

    if id.present?
      object = klass.find(id)
      data = {type: resource, id: object.id}
      object_attributes = request_body['fields'][resource]
      # object_attributes = params[:fields][resource].to_s.split(',')
      object_attributes.each do |attr|
        (data[:attributes] ||= {})[attr] = object.send(attr)
      end
      included = params[:include].to_s.split(',')
      included.each do |include|
        relationships = include.split('.')
        current_object = object
        current_hash = data
        while relationships.present? do
          relationship = relationships.delete_at(0)
          included_object = current_object.send(relationship)
          included_object_type = included_object.class.name.underscore + 's'
          (current_hash[:included] ||= []) << {type: included_object_type, id: included_object.id}
          included_object_attributes = params[:fields][included_object_type].to_s.split(',')
          included_object_attributes.each do |attr|
            (current_hash[:included].find { |key| key[:type] == included_object_type }[:attributes] ||= {})[attr] = included_object.send(attr)
          end
          current_object = included_object
          current_hash = current_hash[:included].find { |key| key[:type] == included_object_type }
        end
      end
    else
      data = []
    end

    # require 'byebug'; byebug
    data
  end

  get '/*' do
    # curl -X GET http://localhost:5000/accounts/1 -H "Content-Type: application/json" -d '{"fields": {"accounts": ["id", "product_cd"]}}'
    json handle
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
