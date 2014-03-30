ENV["RAILS_ENV"] = "test"

require_relative "../config/environment"
require "rspec/rails"
require "rspec/collection_matchers"
require "pry"
require "database_cleaner"

ActiveRecord::Migration.maintain_test_schema!

Dir[Rails.root.join("spec/support/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.before do
    ActionMailer::Base.deliveries.clear
  end

  config.include FactoryGirl::Syntax::Methods

  config.include Helpers::Generic
  config.include Helpers::Controller,  type: :controller
  config.include Helpers::Integration, type: :feature

  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with :truncation
  end

  config.before do |example|
    DatabaseCleaner.strategy = example.metadata[:js] ? :truncation : :transaction
    DatabaseCleaner.start
  end

  config.after do
    DatabaseCleaner.clean
  end
end
