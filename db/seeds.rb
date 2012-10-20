# Deletes all previous records
connection = ActiveRecord::Base.connection
tables = connection.tables.tap { |tables| tables.delete("schema_migrations") }
tables.each { |table| connection.execute "TRUNCATE #{table}" }

%w[schools students].each do |table|
  load("#{Rails.root}/db/seeds/#{table}.rb")
end

Dir["#{Rails.root}/db/seeds/quizzes/**/*.rb"].each do |f|
  load f
end
