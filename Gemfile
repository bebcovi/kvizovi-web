ruby "2.1.1"

source "https://rubygems.org"

gem "rails", ">= 4.1.0.rc2"

# Web servers
gem "thin", group: :development
gem "puma", group: :production

# Database
gem "pg"
gem "pg_search", ">= 0.7.2"
gem "redis", ">= 3"
gem "acts_as_list", ">= 0.3"

# Frontend
group :assets do
  gem "sass-rails", ">= 4.0.0"
  gem "bourbon"
  gem "bootstrap-sass"
  gem "jquery-rails"
  gem "jquery-ui-rails"
  gem "turbolinks", ">= 1.3.1"
  gem "jquery-turbolinks", "~> 1.0"
  gem "coffee-rails", ">= 4.0.0"
  gem "uglifier", ">= 1.3.0"
  gem "momentjs-rails", ">= 2.2.1"
  gem "eco", ">= 1"
end

# Views
gem "haml-rails", ">= 0.5.1"
gem "haml", ">= 4"
gem "simple_form", ">= 3.0.0"
gem "redcarpet", ">= 3"
gem "will_paginate", ">= 3.0.5"
gem "bootstrap-will_paginate", github: "Fleurer/bootstrap-will_paginate"
gem "active_attr", ">= 0.8.1"

# Uploading
gem "carrierwave", ">= 0.9"
gem "mini_magick", ">= 3.6"
gem "fog", ">= 1.17.0"
gem "unf"

# Caching
gem "cache_digests", ">= 0.3"

# Authentication
gem "devise", ">= 3.1.1"

# Helpers
gem "inherited_resources", ">= 1.4.1"
gem "draper", ">= 1.3"
gem "pry-rails", ">= 0.3.2"
gem "bond" # Implicit dependency of Pry

# Security
gem "dotenv"

# Pry
group :pry do
  gem "pry-theme"
  gem "pry-byebug"
  gem "pry-stack_explorer"
  gem "pry-rescue"
end

# Testing
group :test do
  gem "teaspoon", group: :development
  gem "rspec-rails", ">= 3.0.0.beta2", group: :development
  gem "rspec-collection_matchers", ">= 0.0.2"
  gem "factory_girl", ">= 4.2"
  gem "capybara", ">= 2.2.0"
  gem "poltergeist"
  gem "database_cleaner"
end

# Development
group :development do
  gem "spring", ">= 1.1.1"
  gem "quiet_assets", ">= 1.0.2"
  gem "better_errors", ">= 1.0.1"
  gem "binding_of_caller", ">= 0.7.2"
  gem "letter_opener", ">= 1.1.2"
end

# Profiling
gem "rack-mini-profiler", group: :development

# Monitoring
gem "newrelic_rpm", group: :production

# Exceptions
gem "exception_notification", ">= 4.0.1", group: :production

# Heroku
gem "rails_12factor", group: :production
