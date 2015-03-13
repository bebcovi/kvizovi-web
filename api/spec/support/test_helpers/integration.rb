module TestHelpers
  module Integration
    def self.included(base)
      require "rack/test"
      base.include(Rack::Test::Methods)
    end

    def app
      Rack::Builder.parse_file("config.ru").first
    end

    def body
      require "json"
      JSON.parse(last_response.body)
    end

    def status
      last_response.status
    end

    def sent_emails
      Mail::TestMailer.deliveries
    end
  end
end
