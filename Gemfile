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
  gem "animation"
  gem "modular-scale", "~> 1.0.2"
  gem "requirejs-rails"
  gem "jquery-rails"
  gem "jquery-ui-rails"
  gem "coffee-rails"
  gem "uglifier"
end

# Views
gem "haml", "3.2.0.beta.1"
gem "haml-rails"
gem "simple_form"
gem "redcarpet"
gem "rails-i18n"

# Other
gem "paperclip"
gem "paperclip-dropbox", "~> 1.0"
gem "bcrypt-ruby", "~> 3.0"
gem "active_attr"
gem "nokogiri"

group :development do
  gem "pry-rails"
end

group :development, :test do
  gem "rspec-rails"
  gem "debugger", require: "debugger"
end

group :test do
  gem "factory_girl_rails"
  gem "capybara"
  gem "vcr"
  gem "fakeweb"
end
