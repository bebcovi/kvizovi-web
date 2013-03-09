ENV["RAILS_ENV"] = "test"
require "rspec" # for "spring"

require "bundler"
Bundler.setup

ROOT = Bundler.root
Dir[File.join(ROOT, "spec/support/**/*.rb"].each &method(:require)

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
