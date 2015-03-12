require "sinatra/base"
require "symbolize_keys_recursively"

require "kvizovi/account"
require "kvizovi/quizzes"
require "kvizovi/serializer"

require "json"

module Kvizovi
  class Api < Sinatra::Base

    before do
      content_type "application/json"
      params.symbolize_keys_recursively!
    end


    get "/account" do
      json Kvizovi::Account.authenticate(params[:user])
    end

    post "/account" do
      json Kvizovi::Account.register!(params[:user])
    end

    put "/account" do
      json Kvizovi::Account.new(current_user).update!(params[:user])
    end

    delete "/account" do
      json Kvizovi::Account.new(current_user).destroy!
    end

    put "/account/confirm" do
      json Kvizovi::Account.confirm!(params[:token])
    end

    post "/account/password" do
      json Kvizovi::Account.reset_password!(params[:user])
    end

    put "/account/password" do
      json Kvizovi::Account.set_password!(params[:token], params[:user])
    end


    get "/quizzes" do
      json Kvizovi::Quizzes.new(current_user).all
    end

    get "/quizzes/:id" do
      json Kvizovi::Quizzes.new(current_user).find(params[:id])
    end

    post "/quizzes" do
      json Kvizovi::Quizzes.new(current_user).create(params[:quiz])
    end

    put "/quizzes/:id" do
      json Kvizovi::Quizzes.new(current_user).update(params[:id], params[:quiz])
    end

    delete "/quizzes/:id" do
      json Kvizovi::Quizzes.new(current_user).destroy(params[:id])
    end


    error Kvizovi::Error do
      error 400, {errors: env["sinatra.error"].errors}.to_json
    end

    private

    def json(object, **options)
      Kvizovi::Serializer.new(object).serialize(**options)
    end

    def current_user
      Kvizovi::Account.authenticate(token: authorization_token!)
    end

    def authorization_token!
      authorization_token or
        error(401, {errors: ["No authorization token specified"]}.to_json)
    end

    def authorization_token
      header = request.env["HTTP_AUTHORIZATION"]
      header && header[/Token token="(\w+)"/, 1]
    end

  end
end
