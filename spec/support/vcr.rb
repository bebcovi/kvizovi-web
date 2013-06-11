require "vcr"

VCR.configure do |config|
  config.cassette_library_dir = Rails.root.join("spec/support/fixtures/vcr_cassettes")
  config.hook_into :webmock
end
