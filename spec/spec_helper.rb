ENV["RAILS_ENV"] = "test"

require_relative "../config/environment"

Dir[Rails.root.join("spec/support/**/*.rb")].each &method(:require)

require "rspec/rails"
require "capybara/rspec"

Paperclip.options[:log] = false

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include SpecHelpers

  config.include NullDBSpecHelpers

  config.before(:each) { ActionMailer::Base.deliveries.clear }

  config.use_transactional_fixtures = true
end
