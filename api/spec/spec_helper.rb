ENV["RACK_ENV"] = "test"

require_relative "support/test_helpers"

RSpec.configure do |config|
  config.disable_monkey_patching!

  config.around do |example|
    DB.transaction(rollback: :always) { example.run }
  end

  config.include TestHelpers::Factory
  config.include TestHelpers::RSpecMatchers
end
