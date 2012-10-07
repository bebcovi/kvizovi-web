require "active_attr"

class Password
  include ActiveAttr::Model

  attribute :old_password, type: String
  attribute :new_password, type: String
  attribute :new_password_confirmation, type: String

  validate :validate

  def initialize(*args)
    attributes = args.first.is_a?(Hash) ? args.first : {}
    user = args.last.is_a?(ActiveRecord::Base) ? args.last : nil

    super(attributes)
    @user = user
  end

  def save
    if valid?
      @user.update_attributes(password: new_password)
      true
    else
      false
    end
  end

  private

  def validate
    if not @user.authenticate(old_password)
      errors[:old_password] << "Ne podudara se sa trenutnom."
    end

    user = @user.class.new(password: new_password, password_confirmation: new_password_confirmation)
    unless user.valid?
      user.errors[:password].each { |message| errors[:new_password] << message }
      user.errors[:password_confirmation].each { |message| errors[:new_password_confirmation] << message }
    end
  end
end
