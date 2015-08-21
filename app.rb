require 'sinatra'
require 'sinatra/activerecord'
require 'jwt'
require 'byebug' unless ENV['RACK_ENV'] == 'production'
require './lib/bank'

class Bank < Sinatra::Application

  before do
    content_type 'application/json'
    response['Access-Control-Allow-Origin'] = '*'
    authenticate_user unless ['auth', nil].include? request.path_info.split('/')[1]
    parse_request_body if request.env['CONTENT_TYPE'] == 'application/json'
  end

  get '/' do
    content_type 'text/html'
    send_file 'public/index.html'
  end

  # curl -X POST 'localhost:5000/auth' -d "email=<email>&password=<password>" -H "Accept: application/json"
  # curl -X POST 'localhost:5000/auth' -d '{"email": "<email>", "password": "<password>"}' -H "Accept: application/json" -H "Content-Type: application/json"
  post '/auth' do
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      payload = {sub: user.id, iss: 'Diaminx', iat: Time.now.to_i, exp: (Time.now + 24.hours).to_i}
      json token: JWT.encode(payload, secret)
    else
      status 400
      json errors: ['Invalid credentials.']
    end
  end

  # curl 'localhost:5000/accounts' -H "Accept: application/json" -H "Authorization: <token>" -H "Content-Type: application/json"
  get '/accounts' do
    json accounts: Account.all.include_customer_and_product_type
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
      json errors: customer.errors.full_messages
    end
  end

  get '/employees' do
    json Employee.all
  end

  helpers do
    def current_user
      @current_user
    end

    def json(obj)
      obj.to_json
    end

    def parse_request_body
      params = JSON.parse(request.body.read) rescue {}
      params.each { |k, v| @params[k.to_sym] = v }
    end

    def secret
      'secret'
    end

    def authenticate_user
      token = request.env['HTTP_AUTHORIZATION'].split(' ').last
      decoded_token = JWT.decode(token, secret)
      user_id = decoded_token[0]['sub']
      @current_user = User.find(user_id)
    rescue
      halt 400, json(errors: ['Invalid token'])
    end
  end
end
