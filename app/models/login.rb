require "active_attr"

class Login
  include ActiveAttr::Model

  attribute :username,    type: String
  attribute :password,    type: String
  attribute :remember_me, type: Integer

  attr_accessor :user_class
  attr_accessor :user

  validate :validate_authentication_of_user

  def remember_me?
    remember_me == 1
  end

  private

  def validate_authentication_of_user
    if user = user_class.find_by_username(username).try(:authenticate, password)
      self.user = user
    else
      errors.add(:base)
    end
  end
end
