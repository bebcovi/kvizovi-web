require "rack/test"
require "fileutils"

FileUtils.mkdir_p(Rails.root.join("tmp/test"))

module FileHelpers
  extend ActiveSupport::Concern

  FIXTURES_DIR = Rails.root.join("spec/support/fixtures/files")
  TMP_DIR      = Rails.root.join("tmp/test")

  def uploaded_file(original_filename, copy_filename = original_filename, content_type)
    source_path      = File.join(FIXTURES_DIR, original_filename)
    destination_path = File.join(TMP_DIR, copy_filename)
    FileUtils.cp(source_path, destination_path)
    Rack::Test::UploadedFile.new(destination_path, content_type)
  end

  def create_file(filename, content_type, options = {})
    File.open(File.join(TMP_DIR, filename), "w") do |file|
      size = options[:size] || 0
      file.write "a" * 10000 until file.size >= size
    end
    Rack::Test::UploadedFile.new(File.join(TMP_DIR, filename), content_type)
  end
end

RSpec.configure do |config|
  config.include FileHelpers

  config.after(:suite) do
    FileUtils.rm_rf Dir[Rails.root.join("tmp/test/*")]
  end
end
