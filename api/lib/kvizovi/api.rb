require "grape"

require "kvizovi/authorization"
require "kvizovi/account"
require "kvizovi/quizzes"
require "kvizovi/played_quizzes"
require "kvizovi/serializer"

module Kvizovi
  class API < Grape::API

    format :json
    default_format :json
    formatter :json, Kvizovi::Serializer
    default_error_status 400
    do_not_route_head!

    resource :account do
      get do
        Account.authenticate(authorization.value)
      end

      post do
        Account.register!(params[:user])
      end

      put do
        Account.new(current_user).update!(params[:user])
      end

      delete do
        Account.new(current_user).destroy!
      end

      put "/confirm" do
        Account.confirm!(params[:token])
      end

      post "/password" do
        Account.reset_password!(params[:user])
      end

      put "/password" do
        Account.set_password!(params[:token], params[:user])
      end
    end

    resources :quizzes do
      get do
        if authorization.present?
          Quizzes.new(current_user).all
        else
          Quizzes.search(params)
        end
      end

      post do
        Quizzes.new(current_user).create(params[:quiz])
      end

      route_param :id do
        get do
          if authorization.present?
            Quizzes.new(current_user).find(params[:id])
          else
            Quizzes.find(params[:id])
          end
        end

        put do
          Quizzes.new(current_user).update(params[:id], params[:quiz])
        end

        delete do
          Quizzes.new(current_user).destroy(params[:id])
        end
      end
    end

    resources :played_quizzes do
      post do
        players = params[:players].map { |token| Account.authenticate(:token, token) }
        PlayedQuizzes.create(params[:played_quiz], players)
      end

      get do
        PlayedQuizzes.new(current_user).search(params)
      end
    end

    helpers do
      def current_user
        Account.authenticate(:token, authorization.token)
      end

      def authorization
        Authorization.new(headers["Authorization"])
      end

      def params
        super.to_hash.deep_symbolize_keys! # Die, Hashie::Mash
      end
    end

    rescue_from Kvizovi::Unauthorized do |error|
      rack_response({errors: [error.message]}.to_json, 401)
    end

  end
end
