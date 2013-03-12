require "active_attr"

class Authorization
  include ActiveAttr::Model

  attribute :secret_key

  def valid?
    secret_key == ENV["LEKTIRE_KEY"]
  end
end
