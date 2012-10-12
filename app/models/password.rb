# encoding: utf-8
require "active_attr"

class Password
  include ActiveAttr::Model

  attribute :old_password, type: String
  attribute :new_password, type: String
  attribute :new_password_confirmation, type: String
  attr_accessor :user

  validate :validate_old_password
  validates_presence_of :new_password, message: "Ne smije biti prazna"
  validates_confirmation_of :new_password, message: "Ne slaže se sa svojom potvrdom"

  def save
    if valid?
      user.update_attributes(password: new_password)
      true
    else
      false
    end
  end

  private

  def validate_old_password
    if not user.authenticate(old_password)
      errors[:old_password] << "Ne podudara se sa trenutnom lozinkom."
    end
  end
end
