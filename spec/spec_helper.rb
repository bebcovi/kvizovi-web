require_relative "spec_helper_lite"

require_relative "../config/environment"

require "rspec/rails"
require "capybara/rspec"

Paperclip.options[:log] = false

RSpec.configure do |config|
  config.include IntegrationSpecHelpers
  config.use_transactional_fixtures = true
end
