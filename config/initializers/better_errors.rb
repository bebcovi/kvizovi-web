if Rails.env.development?
  require "better_errors"

  BetterErrors.use_pry!
end
