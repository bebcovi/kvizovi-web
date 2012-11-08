require "active_attr"

class Session
  include ActiveAttr::Model
  attr_accessor :type

  attribute :username
  attribute :password
  attribute :remember_me

  def remember_me?
    remember_me == 1
  end

  def authenticate_user
    user_class.authenticate(username: username, password: password)
  end

  private

  def user_class
    type.camelize.constantize
  end
end
