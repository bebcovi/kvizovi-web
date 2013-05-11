require "database_cleaner"

DatabaseCleaner.clean_with :truncation

%w[schools students quizzes].each do |table|
  load("#{Rails.root}/db/seeds/#{table}.rb")
end
