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
      email:         "Ne postoji korisnik s tom email adresom",
      credentials:   "Pogrešan email ili lozinka",
      expired:       "Morate potvrditi svoj korisnički račun",
      token_missing: "No authorization token given",
      token:         "No user with that token",
    }
  end
end
