require "active_attr"

class Login
  include ActiveAttr::Model

  attribute :username,    type: String
  attribute :password,    type: String
  attribute :remember_me, type: Integer

  attr_accessor :user_class
  attr_accessor :user

  def remember_me?
    remember_me == 1
  end

  def valid?
    self.user = UserAuthenticator.new(user_class).authenticate(username: username, password: password)
  end
end
