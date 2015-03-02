require "kvizovi/configuration"
require "kvizovi/api"

require "securerandom"

module Kvizovi
  def self.generate_token
    SecureRandom.hex
  end
end
