ruby "1.9.3"

source :rubygems

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

# Database
gem "paperclip"
gem "paperclip-dropbox", "~> 1.0"
gem "bcrypt-ruby", "~> 3.0"
gem "activerecord-postgres-hstore"
gem "acts-as-taggable-on"

# Other
gem "active_attr"
gem "nokogiri"
gem "exception_notification"
gem "will_paginate", require: ["will_paginate", "will_paginate/array"]

group :development do
  gem "letter_opener"
end

group :development, :test do
  gem "pry-rails"
  gem "rspec-rails"
  gem "debugger"
end

group :test do
  gem "factory_girl"
  gem "capybara"
  gem "activerecord-nulldb-adapter", ">= 0.2.3"
  gem "database_cleaner"
end
