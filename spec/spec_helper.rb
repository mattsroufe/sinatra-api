ENV['RACK_ENV'] = 'test'

require './app'
require 'minitest/autorun'
require 'rack/test'

db_options = YAML.load(File.read('./config/database.yml'))
ActiveRecord::Base.establish_connection(db_options['test'])

include Rack::Test::Methods

def app
  Bank
end
