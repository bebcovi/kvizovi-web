ENV["RAILS_ENV"] = "test"

require_relative "../config/environment"
require "rspec/rails"
require "pry"
require "vcr"

Dir[Rails.root.join("spec/support/*.rb")].each &method(:require)

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.expect_with(:rspec) { |c| c.syntax = :expect }

  config.before do
    ActionMailer::Base.deliveries.clear
  end
end

VCR.configure do |config|
  config.cassette_library_dir = Rails.root.join("spec/support/fixtures/vcr_cassettes")
  config.hook_into :webmock
end
