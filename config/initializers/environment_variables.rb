if Rails.env.development? or Rails.env.test?
  require "dotenv"
  Dotenv.load
end
