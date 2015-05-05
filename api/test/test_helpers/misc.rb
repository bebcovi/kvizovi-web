require "uri"

module TestHelpers
  module Misc
    def sent_emails
      SimpleMailer.emails_sent.map do |message, from, to|
        {message: message, from: from, to: to}
      end
    end

    def email_link
      last_message = sent_emails.last[:message]
      url = URI(last_message[%r{http://\S+$}])
      url.request_uri
    end

    def image
      Rack::Test::UploadedFile.new("test/fixtures/image.jpg")
    end
  end
end
