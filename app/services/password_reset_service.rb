require "securerandom"

class PasswordResetService
  def initialize(user)
    @user = user
  end

  def reset_password
    new_password = generate_random_string
    @user.update_attributes(password: new_password)
    new_password
  end

  def generate_confirmation_id
    confirmation_id = generate_random_string
    @user.update_attributes(password_reset_confirmation_id: confirmation_id)
    confirmation_id
  end

  private

  def generate_random_string
    SecureRandom.hex(5)
  end
end
