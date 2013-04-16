require "fileutils"

Paperclip.options[:log] = false

RSpec.configure do |config|
  config.after(:suite) do
    FileUtils.rm_rf Rails.root.join("tmp/test/*")
  end
end
