require "active_attr"

class Password
  include ActiveAttr::Model

  attribute :old, type: String
  attribute :new, type: String

  attr_accessor :user

  validate :validate_that_the_old_password_matches_the_current_one
  validates :new, presence: true, confirmation: true

  def save
    if valid?
      persist!
      true
    else
      false
    end
  end

  def persist!
    user.update_attributes(password: new)
  end

  private

  def validate_that_the_old_password_matches_the_current_one
    if not user.authenticate(old)
      errors[:old] << "Ne podudara se sa trenutnom lozinkom."
    end
  end
end
