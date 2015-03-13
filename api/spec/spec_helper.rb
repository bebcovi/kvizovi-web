ENV["RACK_ENV"] = "test"

require_relative "support/test_helpers"

RSpec.configure do |config|
  config.disable_monkey_patching!

  config.around do |example|
    if self.class.ancestors.include?(TestHelpers::Integration)
      example.run
      (DB.tables - [:schema_info]).each { |table| DB[table].delete }
    else
      DB.transaction(rollback: :always) { example.run }
    end
  end

  config.include TestHelpers::Factory
  config.include TestHelpers::RSpecMatchers
end
