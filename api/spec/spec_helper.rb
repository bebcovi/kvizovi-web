ENV["RACK_ENV"] = "test"

def benchmark(name = nil)
  time = Time.now
  result = yield
  puts "#{name} (#{Time.now - time})"
  result
end

require_relative "support/test_helpers"

RSpec.configure do |config|
  config.disable_monkey_patching!

  config.around do |example|
    DB.transaction(rollback: :always) { example.run }
  end

  config.include TestHelpers::Misc
  config.include TestHelpers::Factory

  config.after do
    SimpleMailer.emails_sent.clear if defined?(SimpleMailer)
  end
end
