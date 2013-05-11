require "redis"

if Rails.env.production?
  $redis = Redis.connect(url: ENV["REDISTOGO_URL"])
else
  $redis = Redis.new
end
