require "active_attr"

class Login
  include ActiveAttr::Model

  attribute :username,    type: String
  attribute :password,    type: String
  attribute :remember_me, type: Integer

  def remember_me?
    remember_me == 1
  end
end
