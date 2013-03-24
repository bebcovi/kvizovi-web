ruby "2.0.0"

source "https://rubygems.org"

gem "rails", "~> 3.2.12"

# Web servers
gem "thin",    group: :development
gem "unicorn", group: :production

# Frontend
group :assets do
  gem "sass-rails"
  gem "compass", "~> 0.13.alpha.0"
  gem "compass-rails"
  gem "anjlab-bootstrap-rails", require: "bootstrap-rails"
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
gem "rails-i18n"
gem "will_paginate", ">= 3", require: ["will_paginate", "will_paginate/array"]
gem "bootstrap-will_paginate"

# Database
gem "pg"
gem "paperclip", ">= 3.3"
gem "paperclip-dropbox", "~> 1.0"
gem "bcrypt-ruby", "~> 3.0"
gem "activerecord-postgres-hstore"
gem "activerecord-postgres-array"
gem "acts-as-taggable-on"
gem "squeel"

# Security
gem "strong_parameters", ">= 0.2"
gem "dotenv", group: [:development, :test]

# Other
gem "active_attr"

group :test do
  gem "rspec-rails"
  gem "capybara", ">= 2"
  gem "factory_girl_rails", ">= 4.2"
  gem "guard-rspec", ">= 2.4.1"
  gem "rb-inotify", "~> 0.8.8"
  gem "pry"
  gem "nokogiri"
end

# Development stuff
group :development do
  gem "letter_opener"
  gem "pry-rails"
  gem "better_errors"
  gem "binding_of_caller", ">= 0.7.1"
end

group :production do
  gem "exception_notification"
end
