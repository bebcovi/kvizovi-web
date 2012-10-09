ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rspec/rails"
require "rspec/autorun"
require "capybara/rspec"
require_relative "spec_helper_lite"

RSpec.configure do |config|
  config.include IntegrationSpecHelpers

  config.infer_base_class_for_anonymous_controllers = true

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.clean
  end
end
