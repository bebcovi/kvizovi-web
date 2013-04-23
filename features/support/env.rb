require "cucumber/rails"
require "pry"

Before("@school")  { @user_type = "school" }
Before("@student") { @user_type = "student" }

DatabaseCleaner.clean_with :truncation
