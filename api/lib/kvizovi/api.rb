require "grape"

require "kvizovi/authorization"
require "kvizovi/serializer"
require "kvizovi/error"

require "kvizovi/services/account"
require "kvizovi/services/quizzes"
require "kvizovi/services/played_quizzes"

module Kvizovi
  class API < Grape::API

    format :json
    default_format :json
    formatter :json, Kvizovi::Serializer
    default_error_status 400
    do_not_route_head!

    resource :account do
      get do
        Services::Account.authenticate(authorization.value)
      end

      post do
        Services::Account.register!(params[:user])
      end

      put do
        Services::Account.new(current_user).update!(params[:user])
      end

      delete do
        Services::Account.new(current_user).destroy!
      end

      put "/confirm" do
        Services::Account.confirm!(params[:token])
      end

      post "/password" do
        Services::Account.reset_password!(params[:user])
      end

      put "/password" do
        Services::Account.set_password!(params[:token], params[:user])
      end

      resources :quizzes do
        get do
          Services::Quizzes.new(current_user).all
        end

        post do
          Services::Quizzes.new(current_user).create(params[:quiz])
        end

        route_param :id do
          get do
            Services::Quizzes.new(current_user).find(params[:id])
          end

          put do
            Services::Quizzes.new(current_user).update(params[:id], params[:quiz])
          end

          delete do
            Services::Quizzes.new(current_user).destroy(params[:id])
          end
        end
      end
    end

    resources :quizzes do
      get do
        Services::Quizzes.search(params)
      end

      route_param :id do
        get do
          Services::Quizzes.find(params[:id])
        end
      end
    end

    resources :played_quizzes do
      post do
        players = params[:players]
          .map { |token| Services::Account.authenticate(:token, token) }
        Services::PlayedQuizzes.create(params[:played_quiz], players)
      end

      get do
        Services::PlayedQuizzes.new(current_user).search(params)
      end
    end

    post "/contact" do
      Kvizovi.mailer.send(:contact, params)
    end

    helpers do
      def current_user
        Services::Account.authenticate(:token, authorization.token)
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
