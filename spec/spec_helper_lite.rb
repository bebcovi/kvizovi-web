ROOT = File.expand_path("../", File.dirname(__FILE__))
Dir["#{ROOT}/spec/support/**/*.rb"].each { |f| require f }

require "debugger"

require "factory_girl"
require_relative "factories"

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include UnitSpecHelpers
  config.include NullDBSpecHelpers
end

require "vcr"

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :fakeweb
end
