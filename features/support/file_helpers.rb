require "rack/test"

module FileHelpers
  def uploaded_file(filename, content_type)
    Rack::Test::UploadedFile.new(file_path(filename), content_type)
  end

  def file_path(filename)
    Rails.root.join("features/support/fixtures/files/#{filename}")
  end
end

World(FileHelpers)
