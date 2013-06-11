require "vcr"

VCR.configure do |config|
  config.allow_http_connections_when_no_cassette = true
end
