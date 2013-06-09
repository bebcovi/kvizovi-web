ruby "2.0.0"

source "https://rubygems.org"

gem "rails", github: "rails/rails", branch: "3-2-stable"

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
gem "cache_digests"

# Database
gem "pg"
gem "paperclip", ">= 3.3"
gem "paperclip-dropbox", "~> 1.0"
gem "activerecord-postgres-hstore"
gem "squeel", ">= 1"
gem "paper_trail", ">= 2.7"
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
  gem "vcr"
  gem "webmock", ">= 1.8", "< 1.10"
  gem "timecop"
  gem "poltergeist", ">= 1.3"
end

# Development stuff
group :development do
  gem "pry-rails"
  gem "better_errors"
  gem "xray-rails"
  gem "binding_of_caller", ">= 0.7.1"
end

# For Spring
gem "rb-inotify", group: [:development, :test]

group :production do
  gem "exception_notification"
end
