require "kvizovi/api"
require "kvizovi/mailer"

require "bcrypt"

require "securerandom"

module Kvizovi
  def self.generate_token
    ::SecureRandom.hex
  end

  def self.mailer
    Mailer.new
  end

  def self.hash(string)
    ::BCrypt::Password.create(string)
  end

  def self.password(string)
    ::BCrypt::Password.new(string)
  end
end
