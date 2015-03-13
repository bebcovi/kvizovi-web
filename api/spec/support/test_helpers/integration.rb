module TestHelpers
  module Integration
    def self.included(base)
      require "thin"
      require "logger"

      app = Rack::Builder.parse_file("config.ru").first
      server = Thin::Server.new(app, "localhost", 8080)
      Thin::Logging.logger = Logger.new(nil)
      Thread.new { server.start } and (:wait until server.running?)
    end

    require "forwardable"
    extend Forwardable
    delegate [:get, :post, :put, :delete, :head] => :connection

    def connection
      @connection ||= (
        require "faraday"
        require "faraday_middleware"

        Faraday.new("http://127.0.0.1:8080") do |builder|
          builder.request  :json
          builder.response :json
          builder.adapter  :net_http
        end
      )
    end

    def sent_emails
      Mail::TestMailer.deliveries
    end
  end
end
