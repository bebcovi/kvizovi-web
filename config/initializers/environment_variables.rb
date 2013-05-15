unless Rails.env.production?
  require "dotenv"
  Dotenv.load
end
