require 'rubygems'
require 'committee'
require 'multi_json'
require 'securerandom'
require 'bundler/setup'
require 'sinatra/base'
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

  use Committee::Middleware::RequestValidation, schema: SCHEMA, strict: true

  before do
    content_type 'application/json'
    response['Access-Control-Allow-Origin'] = '*'
  end

  def handle
    schema_link = request.env[:link] # link object from committee gem
    schema_object = schema_link.parent

    resource, id = params['captures'][0].split('/')
    klass = schema_object.title.constantize

    request.body.rewind
    request_body = request.body.read
    request_body = request_body.present? ? MultiJson.decode(request_body) : params

# this works so far
# http://localhost:5000/api/v1/accounts/1?include=customer,product.product_type&fields[product_types]=name&fields[products]=product_type_cd&fields[accounts]=product_cd,open_date&fields[customers]=city,address

    if id.present?
      object = klass.find(id)
      data = {type: resource, id: object.id}

      if request_body['fields']
        object_attributes = fields = request_body['fields'][resource]
      else
        object_attributes = schema_object.properties.keys
      end

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

    data
  end

  get '/schema' do
    MultiJson.encode SCHEMA
  end

  get '/*' do
    # curl -X GET http://localhost:5000/accounts/1 -H "Content-Type: application/json" -d '{"fields": {"accounts": ["id", "product_cd"]}}'
    MultiJson.encode handle
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
