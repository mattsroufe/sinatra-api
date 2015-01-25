require 'rack/cors'
use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: [ :get, :post, :put, :delete, :options ]
  end
end

require './app'
use Rack::Session::Cookie
run Rack::Cascade.new [Bank::API, Bank::Web]
