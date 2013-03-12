require "active_attr"

class Login
  include ActiveAttr::Model

  attribute :username
  attribute :password
  attribute :remember_me

  def remember_me?
    remember_me == 1
  end

  def authenticate(type)
    UserAuthenticator.new(user(type)).authenticate(password)
  end

  private

  def user(type)
    user_class(type).find_by_username(username)
  end

  def user_class(type)
    type.camelize.constantize
  end
end
