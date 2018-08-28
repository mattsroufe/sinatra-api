require 'sinatra/base'
require 'sinatra/activerecord'
require 'jwt'
require 'net/http'
require 'byebug' unless Sinatra::Base.production?
require './lib/bank'

class Bank < Sinatra::Application

  before do
    content_type 'application/json'
    response['Access-Control-Allow-Origin'] = request.env['HTTP_ORIGIN'] || '*'
    response['Access-Control-Allow-Credentials'] = 'true'
    # authenticate_user unless ['auth', 'signup', nil].include?(request.path_info.split('/')[-1]) || request.options?
    parse_request_body if request.env['CONTENT_TYPE'] =~ /application\/json/
  end

  options '*' do
    content_type 'text/plain'
    headers 'Access-Control-Allow-Headers' => 'Accept, Authorization, Content-Type',
            'Access-Control-Allow-Methods' => 'GET, POST, PUT, PATCH, DELETE, OPTIONS, LINK, UNLINK'
  end

  get '/' do
    content_type 'text/html'
    send_file 'public/index.html'
  end

  get '/users/current' do
    send_auth_response
  end

  post '/signup' do
    @current_user = User.new(email: params[:email])
    if current_user.save
      send_auth_response
    else
      json errors: ['Invalid signup']
    end
  end

  post '/auth' do
    @current_user = User.find_by(username: params[:username])

    if current_user && current_user.valid?
      send_auth_response
    else
      status 400
      json errors: ['Invalid credentials.']
    end
  end

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

  get '/employees/:id' do
    EmployeeSerializer.build(current_user, options).serialized_json
  end

  get '/employees' do
    # EmployeeSerializer.build(current_user, options).serialized_json
    json EmployeesQuery.new.select(:emp_no, :full_name, :current_department, :current_department_manager).where('departments.dept_name' => 'Customer Service').order('current_department').limit(10)
  end

  helpers do
    def current_user
      @current_user
    end

    def options
      params
    end

    def send_auth_response
      payload = {
        sub:   current_user.username,
        iss:   'Diaminx',
        iat:   Time.now.to_i,
        exp:   (Time.now + 24.hours).to_i
      }
      response.set_cookie('access_token', {
        value:    JWT.encode(payload, secret),
        path:     '/',
        expires:  Time.now + 24.hours,
        secure:   Sinatra::Base.production?,
        httponly: true
      })
      json JWT.encode(payload, secret)
    end

    def secret
      'secret'
    end

    def json(obj)
      obj.to_json
    end

    def parse_request_body
      params = JSON.parse(request.body.read) rescue {}
      params.each { |k, v| @params[k.to_sym] = v }
    end

    def authenticate_user
      token = request.env['HTTP_TOKEN']
      @current_user = User.find_by(username: token)
      halt 400, json(errors: ['Invalid token']) unless @current_user
    end
  end

  run! if app_file == $0
end
