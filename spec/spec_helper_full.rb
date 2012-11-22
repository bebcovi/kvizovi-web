ENV["RAILS_ENV"] ||= "test"
require_relative "spec_helper_lite"

require_relative "../config/environment"

require "rspec/rails"
require "rspec/autorun"
require "capybara/rspec"

Paperclip.options[:log] = false

RSpec.configure do |config|
  config.include IntegrationSpecHelpers

  config.before(:all) do
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.clean
  end
end
