ENV["RACK_ENV"] = "test"

require "benchmark"

require_relative "support/test_helpers"

RSpec.configure do |config|
  config.disable_monkey_patching!

  config.around do |example|
    DB.transaction(rollback: :always) { example.run }
  end

  config.include TestHelpers::Factory
end
