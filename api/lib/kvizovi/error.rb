module Kvizovi
  class Error < ArgumentError
    def initialize(payload)
      super(payload)
      @payload = payload
    end

    def errors
      case @payload
      when Hash
        @payload
      when Array
        @payload.map do |message|
          String === message ? message : translate(message)
        end
      end
    end

    private

    def translate(name)
      TRANSLATIONS.fetch(name)
    end

    TRANSLATIONS = {
      email_authentication:       "Ne postoji korisnik s tom email adresom",
      credentials_authentication: "Pogrešan email ili lozinka",
      account_expired:            "Morate potvrditi svoj korisnički račun",
    }
  end
end
