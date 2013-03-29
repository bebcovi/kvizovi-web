ENV["RAILS_ENV"] = "test"

require_relative "../config/environment"

Dir[Rails.root.join("spec/support/**/*.rb")].each &method(:require)

require "rspec/rails"
require "capybara/rspec"

Paperclip.options[:log] = false
I18n.backend.send(:init_translations)

RSpec.configure do |config|
  config.use_transactional_fixtures = true

  config.before(:each) do
    ActionMailer::Base.deliveries.clear
  end

  config.include FactoryGirl::Syntax::Methods
  config.include Helpers

  config.alias_example_to :they
end
