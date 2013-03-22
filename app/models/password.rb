require "active_attr"

class Password
  include ActiveAttr::Model

  attribute :old, type: String
  attribute :new, type: String

  attr_accessor :user

  validate :validate_that_the_old_password_matches_the_current_one
  validates :new, presence: true, confirmation: true

  private

  def validate_that_the_old_password_matches_the_current_one
    if not user.authenticate(old)
      errors.add(:old, :confirmation)
    end
  end
end
