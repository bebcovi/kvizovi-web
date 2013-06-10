ruby "2.0.0"

source "https://rubygems.org"

gem "rails", "3.2.13"

# Web servers
gem "thin",    group: :development
gem "unicorn", group: :production

# Frontend
group :assets do
  gem "sass-rails"
  gem "bourbon"
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
gem "will_paginate", ">= 3"
gem "bootstrap-will_paginate"
gem "draper"
gem "cache_digests", ">= 0.3"

# Database
gem "pg"
gem "paperclip", ">= 3.3"
gem "paperclip-dropbox", ">= 1.1.5"
gem "squeel", ">= 1"
gem "redis", ">= 3"
gem "acts_as_list", ">= 0.2"

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
  gem "vcr", ">= 2.5"
  gem "webmock", ">= 1.11"
  gem "timecop"
  gem "poltergeist", ">= 1.3"
end

# Development stuff
group :development do
  gem "pry-rails"
  gem "better_errors"
  gem "xray-rails"
end

group :development, :test do
  gem "rb-inotify" # For spring
end

group :production do
  gem "exception_notification"
end
