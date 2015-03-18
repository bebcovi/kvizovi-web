module Kvizovi
  class Error < ArgumentError
    class << self
      attr_accessor :translations
    end

    def initialize(symbol)
      super translate(symbol)
    end

    private

    def translate(name)
      self.class.translations.fetch(name)
    end
  end

  class Unauthorized < Error
    self.translations = {
      token_missing:         "No authorization token given",
      authorization_missing: "No authorization credentials given",
      email_invalid:         "Ne postoji korisnik s tom email adresom",
      credentials_invalid:   "Pogrešan email ili lozinka",
      token_invalid:         "No user with that token",
      account_expired:       "Morate potvrditi svoj korisnički račun",
    }
  end
end
