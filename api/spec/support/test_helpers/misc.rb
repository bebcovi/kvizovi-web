module TestHelpers
  module Misc
    def sent_emails
      SimpleMailer.emails_sent.map do |message, from, to|
        {message: message, from: from, to: to}
      end
    end

    def image
      Rack::Test::UploadedFile.new("spec/fixtures/image.jpg")
    end
  end
end
