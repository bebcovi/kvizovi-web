require "fileutils"

Paperclip.options[:log] = false

at_exit do
  FileUtils.rm_rf Dir[Rails.root.join("tmp/test/*")]
end
