ENV["RACK_ENV"] = "test"

require "kvizovi"
require "pry"

require "./spec/support/test_helpers"

Mail.defaults { delivery_method :test }
BCrypt::Engine.cost = 1

RSpec.configure do |config|
  config.disable_monkey_patching!

  config.around do |example|
    DB.transaction(rollback: :always) { example.run }
  end

  config.include TestHelpers

  config.after { sent_emails.clear }
end
