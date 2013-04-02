ENV["RAILS_ENV"] = "test"

require_relative "../config/environment"
require "rspec/rails"

Dir[Rails.root.join("spec/support/**/*.rb")].each &method(:require)

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.alias_example_to :they

  config.before do
    ActionMailer::Base.deliveries.clear
  end
end
