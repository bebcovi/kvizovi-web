require "kvizovi/configuration/roda"

require "kvizovi/authorization"
require "kvizovi/error"

require "kvizovi/services/account"
require "kvizovi/services/quizzes"
require "kvizovi/services/played_quizzes"

module Kvizovi
  class API < Roda

    route do |r|
      r.on "account" do
        r.is do
          r.get do
            Services::Account.authenticate(authorization.value)
          end

          r.post do
            Services::Account.register!(params[:user])
          end

          r.put do
            Services::Account.new(current_user).update!(params[:user])
          end

          r.delete do
            Services::Account.new(current_user).destroy!
          end
        end

        r.put "confirm" do
          Services::Account.confirm!(params[:token])
        end

        r.post "password" do
          Services::Account.reset_password!(params[:user])
        end

        r.put "password" do
          Services::Account.set_password!(params[:token], params[:user])
        end

        r.on "quizzes" do
          r.is do
            r.get do
              Services::Quizzes.new(current_user).all
            end

            r.post do
              Services::Quizzes.new(current_user).create(params[:quiz])
            end
          end

          r.is ":id" do |id|
            r.get do
              Services::Quizzes.new(current_user).find(id)
            end

            r.put do
              Services::Quizzes.new(current_user).update(id, params[:quiz])
            end

            r.delete do
              Services::Quizzes.new(current_user).destroy(id)
            end
          end
        end
      end

      r.on "quizzes" do
        r.is do
          r.get do
            Services::Quizzes.search(params)
          end
        end

        r.is ":id" do |id|
          r.get do
            Services::Quizzes.find(id)
          end
        end
      end

      r.on "played_quizzes" do
        r.is do
          r.post do
            players = params[:players]
              .map { |token| Services::Account.authenticate(:token, token) }
            Services::PlayedQuizzes.create(params[:played_quiz], players)
          end

          r.get do
            Services::PlayedQuizzes.new(current_user).search(params)
          end
        end
      end

      r.post "contact" do
        Kvizovi.mailer.send(:contact, params)
      end
    end

    def current_user
      Services::Account.authenticate(:token, authorization.token)
    end

    def authorization
      Authorization.new(env["HTTP_AUTHORIZATION"])
    end

    error do |exception|
      case exception
      when Kvizovi::Unauthorized
        response.status = 401
        {errors: [exception.message]}
      else
        raise exception
      end
    end

  end
end
