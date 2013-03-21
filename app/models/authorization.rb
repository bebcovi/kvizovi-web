require "active_attr"

class Authorization
  include ActiveAttr::Model

  attribute :secret_key

  validates :secret_key, format: {with: /\A#{ENV["SECRET_KEY"]}\Z/}
end
