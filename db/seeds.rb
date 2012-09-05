# Deletes all previous records
tables = ActiveRecord::Base.connection.tables
tables.delete("schema_migrations")
models = tables.map(&:classify).map(&:constantize)
models.each { |model| model.delete_all }

def uploaded_file(filename, content_type)
  Rack::Test::UploadedFile.new("#{Rails.root}/db/seeds/files/#{filename}", content_type)
end

%w[schools students quizzes questions].each do |table|
  load("#{Rails.root}/db/seeds/#{table}.rb")
end
