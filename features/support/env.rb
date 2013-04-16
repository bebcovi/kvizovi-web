require "cucumber/rails"

Before("@school")  { @user_type = "school" }
Before("@student") { @user_type = "student" }

DatabaseCleaner.clean_with :truncation
PaperTrail.enabled = true
