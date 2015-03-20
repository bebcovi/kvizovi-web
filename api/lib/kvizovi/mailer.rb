require "kvizovi/configuration/mail"
require "unindent"

module Kvizovi
  class Mailer
    def password_reset_instructions(user)
      send_email do |email|
        email.from    = "janko.marohnic@gmail.com"
        email.to      = user.email
        email.subject = "Upute za resetiranje lozinke"
        email.body    = <<-BODY.unindent
          Da biste promijenili lozinku, posjetite ovaj link:

          http://kvizovi.org/account/password?token=#{user.password_reset_token}

          Vaši Kvizovi
        BODY
      end
    end

    def registration_confirmation(user)
      send_email do |email|
        email.from    = "janko.marohnic@gmail.com"
        email.to      = user.email
        email.subject = "Dovršite registraciju na Kvizovima"
        email.body    = <<-BODY.unindent
          Da dovršite registraciju, posjetite ovaj link:

          http://kvizovi.org/account/confirm?token=#{user.confirmation_token}

          Vaši Kvizovi
        BODY
      end
    end

    def contact(info)
      send_email do |email|
        email.from     = "janko.marohnic@gmail.com"
        email.reply_to = info.fetch(:email)
        email.to       = "janko.marohnic@gmail.com"
        email.cc       = "matija.marohnic@gmail.com"
        email.subject  = "Kvizovi - kontakt"
        email.body     = info.fetch(:body)
      end
    end

    private

    def send_email
      email = ::Mail.new
      email.charset = "UTF-8"
      yield email
      email.deliver
    end
  end
end
