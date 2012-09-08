# Deletes all previous records
connection = ActiveRecord::Base.connection
tables = connection.tables.tap { |tables| tables.delete("schema_migrations") }
tables.each { |table| connection.execute "TRUNCATE #{table}" }

def uploaded_file(filename, content_type)
  Rack::Test::UploadedFile.new("#{Rails.root}/db/seeds/files/#{filename}", content_type)
end

%w[schools students quizzes questions].each do |table|
  load("#{Rails.root}/db/seeds/#{table}.rb")
end
