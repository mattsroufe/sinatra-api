require 'sinatra'
require 'sinatra/activerecord'
require 'grape'
require 'grape-swagger'

class Post < ActiveRecord::Base
end

class API < Grape::API
  version 'v1'
  format :json
  prefix 'api'

  resource :posts do
    desc 'Returns all posts.'
    get '/' do
      Post.order("created_at DESC")
    end

    desc "Returns a single post."
    params do
      requires :id, type: Integer, desc: "Post id."
    end
    get '/:id' do
      Post.find(params[:id])
    end
  end

  add_swagger_documentation api_version: 'v1'
end

class Web < Sinatra::Base

  get "/apidocs" do
    File.read(File.join('public', 'index.html'))
  end
end
