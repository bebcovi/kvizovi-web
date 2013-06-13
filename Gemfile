ruby "2.0.0"

source "https://rubygems.org"

gem "rails", "4.0.0.rc2"

# Web servers
gem "thin",    group: :development
gem "unicorn", group: :production

# Frontend
group :assets do
  gem "sass-rails", ">= 4.0.0.rc2"
  gem "bourbon"
  gem "bootstrap-sass-rails"
  gem "jquery-rails"
  gem "jquery-ui-rails"
  gem "turbolinks"
  gem "jquery-turbolinks", ">= 1"
  gem "coffee-rails", ">= 4.0.0"
  gem "uglifier", ">= 1.3.0"
end

# Views
gem "haml", ">= 4"
gem "haml-rails"
gem "simple_form", ">= 3.0.0.rc"
gem "redcarpet", ">= 2"
gem "will_paginate", ">= 3"
gem "bootstrap-will_paginate"
gem "draper"
gem "cache_digests", ">= 0.3"

# Database
gem "pg"
gem "paperclip", ">= 3.3"
gem "paperclip-dropbox", ">= 1.1.5"
gem "squeel", github: "ernie/squeel"
gem "redis", ">= 3"
gem "acts_as_list", ">= 0.2"

# Security
gem "dotenv", group: [:development, :test]
gem "bcrypt-ruby", "~> 3.0"

# Other
gem "active_attr", ">= 0.8.1"

group :test do
  gem "rspec-rails", ">= 2.13.2"
  gem "factory_girl", ">= 4.2"
  gem "pry"
  gem "nokogiri"
  gem "capybara", ">= 2"
  gem "cucumber-rails", "1.3.0"
  gem "database_cleaner", ">= 1.0.1"
  gem "vcr", ">= 2.5"
  gem "webmock", ">= 1.11"
  gem "timecop"
  gem "poltergeist", ">= 1.3"
end

# Development stuff
group :development do
  gem "pry-rails"
  gem "better_errors"
  gem "xray-rails", ">= 0.1.5"
end

group :development, :test do
  gem "rb-inotify" # For spring
end

group :production do
  gem "exception_notification"
end
