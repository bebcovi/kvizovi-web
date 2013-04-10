ruby "2.0.0"

source "https://rubygems.org"

gem "rails", "~> 3.2.13"

# Web servers
gem "thin",    group: :development
gem "unicorn", group: :production

# Frontend
group :assets do
  gem "sass-rails"
  gem "compass", "~> 0.13.alpha.0"
  gem "compass-rails"
  gem "bootstrap-sass-rails"
  gem "jquery-rails"
  gem "jquery-ui-rails"
  gem "coffee-rails"
  gem "uglifier"
end

# Views
gem "haml", ">= 4"
gem "haml-rails"
gem "simple_form", ">= 2"
gem "redcarpet", ">= 2"

# Database
gem "pg"
gem "paperclip", ">= 3.3"
gem "paperclip-dropbox", "~> 1.0"
gem "activerecord-postgres-hstore"
gem "acts-as-taggable-on"
gem "squeel"
gem "paper_trail", ">= 2.7"

# Security
gem "strong_parameters", ">= 0.2"
gem "dotenv", group: [:development, :test]
gem "bcrypt-ruby", "~> 3.0"

# Other
gem "active_attr"

group :test do
  gem "rspec-rails"
  gem "factory_girl", ">= 4.2"
  gem "pry"
  gem "nokogiri"
  gem "capybara", ">= 2"
  gem "cucumber-rails"
  gem "database_cleaner"
end

# Development stuff
group :development do
  gem "pry-rails"
  gem "better_errors"
  gem "binding_of_caller", ">= 0.7.1"
  gem "rb-inotify", "~> 0.8.8"
end

group :production do
  gem "exception_notification"
end
