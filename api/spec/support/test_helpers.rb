require "./spec/support/test_helpers/integration"
require "./spec/support/test_helpers/factory"
require "./spec/support/test_helpers/rspec_matchers"

require "rack/test"

module TestHelpers
  include Rack::Test::Methods
  include TestHelpers::Integration
  include TestHelpers::Factory
  include TestHelpers::RSpecMatchers
end
