module Kvizovi
  class Error < ArgumentError
    def initialize(id)
      @id = id
      super translations.fetch(id)
    end

    attr_reader :id

    alias title message

    def status
      400
    end

    private

    def translations
      {}
    end
  end

  class Unauthorized < Error
    def status
      401
    end

    private

    def translations
      {
        token_missing:         "No authorization token given",
        authorization_missing: "No authorization credentials given",
        email_invalid:         "Ne postoji korisnik s tom email adresom",
        credentials_invalid:   "Pogrešan email ili lozinka",
        token_invalid:         "No user with that token",
        account_expired:       "Morate potvrditi svoj korisnički račun",
      }
    end
  end
end
