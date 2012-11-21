ROOT = File.expand_path("../", File.dirname(__FILE__))
Dir["#{ROOT}/spec/support/**/*.rb"].each { |f| require f }

require "factory_girl"
FactoryGirl.find_definitions

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include UnitSpecHelpers
  config.include NullDBSpecHelpers

  config.alias_example_to :they
end

include NullDBSpecHelpers

def use_nulldb(&block)
  setup_nulldb
  yield
  teardown_nulldb
end
