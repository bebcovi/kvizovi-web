ruby "1.9.3"

source "http://bundler-api.herokuapp.com"

gem "thin"
gem "rails"
gem "pg"

group :assets do
  gem "sass-rails"
  gem "compass", "~> 0.13.alpha.0"
  gem "compass-rails"
  gem "susy"
  gem "modular-scale"
  gem "fancybox-rails", github: 'sverigemeny/fancybox-rails'
  gem "coffee-rails"
  gem "uglifier"
end

gem "jquery-rails"
gem "jquery-ui-rails"

# Views
gem "haml", "3.2.0.beta.1"
gem "haml-rails"
gem "simple_form"
gem "redcarpet"
gem "rails-i18n"

# Other
gem "paperclip"
gem "paperclip-dropbox", "~> 1.0"
gem "paperclip-meta"
gem "bcrypt-ruby", "~> 3.0"
gem "active_attr"
gem "nokogiri"
gem "activerecord-postgres-hstore"
gem "exception_notification"

group :development, :test do
  gem "pry-rails"
  gem "rspec-rails"
  gem "debugger"
end

group :test do
  gem "factory_girl"
  gem "capybara"
  gem "activerecord-nulldb-adapter", github: "nulldb/nulldb"
  gem "database_cleaner"
end
