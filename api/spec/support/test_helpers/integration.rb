require "rack/test"
require "json"
require "inflection"

Kvizovi::App.plugin(:not_found) { raise "404 not found" }
APP = Rack::Builder.parse_file("config.ru").first
SimpleMailer.test_mode!
BCrypt::Engine.cost = 1
Refile.logger = Logger.new(nil)

module TestHelpers
  module Integration
    include Rack::Test::Methods

    def token_auth(token)
      {"HTTP_AUTHORIZATION" => "Token token=\"#{token}\""}
    end

    def basic_auth(username, password)
      {"HTTP_AUTHORIZATION" => "Basic #{["#{username}:#{password}"].pack("m*")}"}
    end

    def app
      APP
    end

    [:post, :put, :patch, :delete].each do |http_method|
      alias_method :"#{http_method}_original", http_method
      define_method(http_method) do |uri, params = {}, env = {}, &block|
        env["CONTENT_TYPE"] = "application/json"
        super(uri, params.to_json, env, &block)
      end
    end

    def body
      JSON.parse(last_response.body)
    end

    def data
      body.fetch("data")
    end

    def included
      body.fetch("included")
    end

    def links
      body.fetch("links")
    end

    def resource(name)
      resources(plural(name)).fetch(0)
    end

    def resources(name)
      Array(data).select { |hash| hash["type"] == name }
    end

    def associated_resources(name, linked_name)
      associations(name, linked_name).map do |link|
        included_resource(link["type"], link["id"])
      end
    end

    def associated_resource(name, linked_name)
      associated_resources(name, linked_name).fetch(0)
    end

    def association(name, association_name)
      associations(name, association_name).fetch(0)
    end

    def associations(name, association_name)
      list = resource_links(name).fetch(association_name).fetch("linkage")
      Array(list)
    end

    def included_resource(type, id)
      included_resources(type).select { |hash| hash["id"] == id }.fetch(0)
    end

    def included_resources(type)
      included.select { |hash| hash["type"] == type }
    end

    def resource_links(name)
      resource(name).fetch("links")
    end

    def error
      errors.fetch(0)
    end

    def errors
      body.fetch("errors")
    end

    def status
      last_response.status
    end

    private

    def plural(string)
      Inflection.plural(string)
    end

    def Array(object)
      if Hash === object
        [object]
      else
        super
      end
    end
  end
end
