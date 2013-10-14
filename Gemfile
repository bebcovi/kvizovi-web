ruby "2.0.0"

source "https://rubygems.org"

gem "rails", ">= 4.0.0"

# Web servers
gem "thin",    group: :development
gem "unicorn", group: :production

# Frontend
group :assets do
  gem "sass-rails", ">= 4.0.0"
  gem "bourbon"
  gem "bootstrap-sass-rails"
  gem "jquery-rails"
  gem "jquery-ui-rails"
  gem "turbolinks", ">= 1.3"
  gem "jquery-turbolinks", "~> 1.0"
  gem "coffee-rails", ">= 4.0.0"
  gem "uglifier", ">= 1.3.0"
end

# Views
gem "haml", ">= 4"
gem "haml-rails"
gem "simple_form", ">= 3.0.0"
gem "redcarpet", ">= 2"
gem "will_paginate", ">= 3.0.5"
gem "bootstrap-will_paginate", ">= 0.0.10"
gem "draper"
gem "cache_digests", ">= 0.3"

# Database
gem "pg"
gem "paperclip", ">= 3.5.1"
gem "paperclip-dropbox", ">= 1.1.6"
gem "squeel", ">= 1.1.1"
gem "redis", ">= 3"
gem "acts_as_list", ">= 0.3"

# Security
gem "dotenv", group: [:development, :test]
gem "bcrypt-ruby", "~> 3.0.0"

# Other
gem "active_attr", ">= 0.8.1"

group :test do
  gem "rspec-rails", ">= 2.14"
  gem "factory_girl", ">= 4.2"
  gem "pry"
  gem "nokogiri"
  gem "capybara", ">= 2"
  gem "cucumber-rails", ">= 1.4"
  gem "database_cleaner", ">= 1.2"
  gem "vcr", ">= 2.6"
  gem "webmock", ">= 1.8.0", "< 1.14"
  gem "timecop"
  gem "poltergeist", ">= 1.4.1"
end

# Development stuff
group :development do
  gem "pry-rails", ">= 0.3.2"
  gem "better_errors", ">= 1.0.1"
  gem "binding_of_caller", ">= 0.7.2"
  gem "xray-rails", ">= 0.1.5"
end

group :production do
  gem "exception_notification", ">= 4.0.1"
end
