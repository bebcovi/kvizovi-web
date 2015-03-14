require "grape"
require "refile"
require "refile/image_processing"

require "kvizovi/account"
require "kvizovi/quizzes"
require "kvizovi/serializer"

module Kvizovi
  class API < Grape::API

    format :json
    default_format :json
    formatter :json, Kvizovi::Serializer
    default_error_status 400
    do_not_route_head!

    mount Refile::App => Refile.mount_point

    resource :account do
      get do
        Kvizovi::Account.authenticate(params[:user])
      end

      post do
        Kvizovi::Account.register!(params[:user])
      end

      put do
        Kvizovi::Account.new(current_user).update!(params[:user])
      end

      delete do
        Kvizovi::Account.new(current_user).destroy!
      end

      put "/confirm" do
        Kvizovi::Account.confirm!(params[:token])
      end

      post "/password" do
        Kvizovi::Account.reset_password!(params[:user])
      end

      put "/password" do
        Kvizovi::Account.set_password!(params[:token], params[:user])
      end
    end

    resources :quizzes do
      get do
        if authorization_token
          Kvizovi::Quizzes.new(current_user).all
        else
          Kvizovi::Quizzes.search(params)
        end
      end

      post do
        Kvizovi::Quizzes.new(current_user).create(params[:quiz])
      end

      route_param :id do
        get do
          if authorization_token
            Kvizovi::Quizzes.new(current_user).find(params[:id])
          else
            Kvizovi::Quizzes.find(params[:id])
          end
        end

        put do
          Kvizovi::Quizzes.new(current_user).update(params[:id], params[:quiz])
        end

        delete do
          Kvizovi::Quizzes.new(current_user).destroy(params[:id])
        end
      end
    end

    helpers do
      def current_user
        Kvizovi::Account.authenticate(:token, authorization_token!)
      end

      def authorization_token!
        authorization_token or raise Kvizovi::Unauthorized, :token_missing
      end

      def authorization_token
        headers["Authorization"].to_s[/Token token="(\w+)"/, 1]
      end

      def params
        super.to_hash.deep_symbolize_keys! # 💣  Hashie::Mash
      end
    end

    rescue_from Kvizovi::Unauthorized do |error|
      rack_response({errors: [error.message]}.to_json, 401)
    end

  end
end
