ruby "2.1.0"

source "https://rubygems.org"

gem "rails", ">= 4.0.1"
gem "pg"

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
gem "haml", ">= 4"
gem "simple_form", ">= 3.0.0"
gem "haml-rails", ">= 0.5.1"
gem "redcarpet", ">= 3"
gem "will_paginate", ">= 3.0.5"
gem "bootstrap-will_paginate", github: "Fleurer/bootstrap-will_paginate"
gem "draper", ">= 1.3"
gem "cache_digests", ">= 0.3"

# Database
gem "carrierwave", ">= 0.9"
gem "mini_magick", ">= 3.6"
gem "fog", ">= 1.17.0"
gem "unf"
gem "squeel", ">= 1.1.1"
gem "redis", ">= 3"
gem "acts_as_list", ">= 0.3"
gem "pg_search", ">= 0.7.2"

# Other
gem "devise", ">= 3.1.1"
gem "active_attr", ">= 0.8.1"
gem "inherited_resources", ">= 1.4.1"

# Development
gem "pry", ">= 0.9.12.5"
gem "pry-rails", ">= 0.3.2"
gem "pry-theme"
gem "bond"
gem "pry-debugger"
gem "pry-stack_explorer"
gem "dotenv"

group :test do
  gem "jasminerice", github: "bradphelan/jasminerice"
  gem "rspec-rails", ">= 3.0.0.beta1"
  gem "rspec-collection_matchers", ">= 0.0.2"
  gem "factory_girl", ">= 4.2"
  gem "nokogiri"
  gem "capybara", ">= 2.2.0"
  gem "poltergeist"
  gem "selenium-webdriver"
end

group :development do
  gem "spring", ">= 1.1.1"
  gem "thin"
  gem "quiet_assets", ">= 1.0.2"
  gem "better_errors", ">= 1.0.1"
  gem "binding_of_caller", ">= 0.7.2"
  gem "letter_opener", ">= 1.1.2"
  gem "database_cleaner"
end

group :production do
  gem "puma"
  gem "exception_notification", ">= 4.0.1"
  gem "newrelic_rpm"
  gem "rails_12factor"
end
