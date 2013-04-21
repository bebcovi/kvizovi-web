require "fileutils"

Paperclip.options[:log] = false

RSpec.configure do |config|
  config.after(:suite) do
    FileUtils.rm_rf Dir[Rails.root.join("tmp/test/*")]
  end
end
