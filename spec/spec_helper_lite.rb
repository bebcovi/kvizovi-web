ROOT = File.expand_path("../", File.dirname(__FILE__))
Dir["#{ROOT}/spec/support/**/*.rb"].each { |f| require f }

require "factory_girl"
Dir["#{ROOT}/spec/factories/**/*.rb"].each { |f| require f }

require "paperclip"
Paperclip.options[:log] = false

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include UnitSpecHelpers
  config.include NullDBSpecHelpers
end

require "vcr"

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :fakeweb
end

require "debugger"
