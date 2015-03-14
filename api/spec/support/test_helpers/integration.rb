require "rack/test"
require "json"

module TestHelpers
  module Integration
    include Rack::Test::Methods

    def app
      Kvizovi::API
    end

    [:post, :put, :delete].each do |http_method|
      alias_method :"#{http_method}_original", http_method
      define_method(http_method) do |uri, params = {}, env = {}, &block|
        env["CONTENT_TYPE"] = "application/json"
        super(uri, params.to_json, env, &block)
      end
    end

    def body
      JSON.parse(last_response.body)
    end

    def status
      last_response.status
    end

    def sent_emails
      Mail::TestMailer.deliveries
    end

    def image
      Rack::Test::UploadedFile.new("spec/fixtures/image.jpg")
    end
  end
end
