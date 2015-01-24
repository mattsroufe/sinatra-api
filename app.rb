require 'sinatra'
require 'sinatra/activerecord'
require 'grape'
require 'grape-swagger'
require './environments'

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
  end

  add_swagger_documentation api_version: 'v1'
end

class Web < Sinatra::Base

  get "/" do
    @posts = Post.order("created_at DESC")
    @title = "Welcome."
    erb :"posts/index"
  end

  helpers do
    def title
      if @title
        "#{@title}"
      else
        "Welcome."
      end
    end
  end

  get "/posts/create" do
   @title = "Create post"
   @post = Post.new
   erb :"posts/create"
  end

  post "/posts" do
   @post = Post.new(params[:post])
   if @post.save
     redirect "posts/#{@post.id}"
   else
     erb :"posts/create"
   end
  end

  get "/posts/:id" do
   @post = Post.find(params[:id])
   @title = @post.title
   erb :"posts/view"
  end
end
