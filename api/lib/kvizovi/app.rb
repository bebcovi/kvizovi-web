require "roda"
require "kvizovi/configuration/refile"

require "kvizovi/authorization"
require "kvizovi/serializer"
require "kvizovi/mailer"
require "kvizovi/mediators/account"
require "kvizovi/error"

module Kvizovi
  class App < Roda
    plugin :all_verbs
    plugin :json,
      classes: Serializer::CLASSES,
      serializer: Serializer, include_request: true
    plugin :json_parser
    plugin :symbolized_params
    plugin :error_handler
    plugin :multi_route
    plugin :heartbeat

    route do |r|
      r.multi_route

      r.post "contact" do
        Mailer.send(:contact, resource(:email)) and ""
      end

      r.on Refile.mount_point do
        r.run Refile::App
      end
    end

    def current_user
      authenticate(:token, authorization.token)
    end

    def authorization
      Authorization.new(env["HTTP_AUTHORIZATION"])
    end

    def authenticate(*args)
      Mediators::Account.authenticate(*args)
    end

    def resource(name)
      params.fetch(:data).tap do |attributes|
        [:type, :id].each { |field| attributes.delete(field) }
      end
    end

    error do |error|
      if Kvizovi::Error === error
        response.status = error.status
        error
      else
        raise error
      end
    end
  end
end

require "kvizovi/routes/account"
require "kvizovi/routes/quizzes"
require "kvizovi/routes/gameplays"
