ENV["RAILS_ENV"] = "test"

Dir[Rails.root.join("spec/support/**/*.rb")].each &method(:require)

require_relative "../config/environment"

require "rspec/rails"
require "capybara/rspec"

Paperclip.options[:log] = false

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include SpecHelpers

  config.include NullDBSpecHelpers
  config.around(:each) do |example|
    if example.metadata[:nulldb]
      use_nulldb { example.run }
    end
  end

  config.use_transactional_fixtures = true
  config.treat_symbols_as_metadata_keys_with_true_values = true
end
