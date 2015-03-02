require "mail"
require "unindent"

module Kvizovi
  class Mailer
    def initialize(user)
      @user = user
    end

    def password_reset_instructions
      send_email do |email|
        email.charset = "UTF-8"
        email.from    = "janko.marohnic@gmail.com"
        email.to      = @user.email
        email.subject = "Upute za resetiranje lozinke"
        email.body    = <<-BODY.unindent
          Da biste promijenili lozinku, posjetite ovaj link:

          http://kvizovi.org/account/password?token=#{@user.password_reset_token}

          Vaši Kvizovi
        BODY
      end
    end

    def registration_confirmation
      send_email do |email|
        email.charset = "UTF-8"
        email.from    = "janko.marohnic@gmail.com"
        email.to      = @user.email
        email.subject = "Dovršite registraciju na Kvizovima"
        email.body    = <<-BODY.unindent
          Da dovršite registraciju, posjetite ovaj link:

          http://kvizovi.org/account/confirm?token=#{@user.confirmation_token}

          Vaši Kvizovi
        BODY
      end
    end

    private

    def send_email
      email = ::Mail.new
      yield email
      email.deliver
    end
  end
end
