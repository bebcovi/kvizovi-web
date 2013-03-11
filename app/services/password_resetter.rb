require "securerandom"

class PasswordResetter
  def initialize(user)
    @user = user
  end

  def reset_password
    new_password = generate_new_password
    @user.update_attributes(password: new_password)
    new_password
  end

  private

  def generate_new_password
    SecureRandom.hex(5)
  end
end
