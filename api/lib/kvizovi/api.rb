require "sinatra/base"
require "symbolize_keys_recursively"

require "kvizovi/account"

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

    error Kvizovi::Error do
      error 400, {errors: env["sinatra.error"].errors}.to_json
    end

    private

    def json(object)
      object.to_json
    end

    def current_user
      Kvizovi::Account.authenticate(token: authorization_token)
    end

    def authorization_token
      request.env["HTTP_AUTHORIZATION"][/Token token="(\w+)"/, 1]
    end
  end
end
