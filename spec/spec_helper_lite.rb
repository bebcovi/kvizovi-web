require "vcr"
require "debugger"

ROOT = File.expand_path("../", File.dirname(__FILE__))
Dir["#{ROOT}/spec/support/**/*.rb"].each { |f| require f }

require "factory_girl"
require_relative "factories"

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include UnitSpecHelpers
  config.treat_symbols_as_metadata_keys_with_true_values = true

  config.before(:each) do |example_group|
    if example_group.example.metadata[:nulldb]
      require "nulldb"
      NullDB.nullify(schema: "#{ROOT}/db/schema.rb")
    end
  end

  config.after(:each) do |example_group|
    if example_group.example.metadata[:nulldb]
      begin
        NullDB.restore
      rescue ActiveRecord::ConnectionNotEstablished
      end
    end
  end
end

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :fakeweb
end
