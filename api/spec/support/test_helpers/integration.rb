require "json"

module TestHelpers
  module Integration
    def app
      Rack::Builder.parse_file("config.ru").first
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
  end
end
