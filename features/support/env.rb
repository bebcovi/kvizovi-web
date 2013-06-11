require "cucumber/rails"
require "pry"

DatabaseCleaner.clean_with :truncation

Before() do
  host! "example.com"
end
