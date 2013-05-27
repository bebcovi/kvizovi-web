require "active_attr"

class Login
  include ActiveAttr::Model

  attribute :username,    type: String
  attribute :password,    type: String

  attr_accessor :user_class
  attr_accessor :user

  validate :validate_authentication_of_user

  private

  def validate_authentication_of_user
    if user = UserAuthenticator.new(user_class).authenticate(username, password)
      self.user = user
    else
      errors.add(:base)
    end
  end
end
