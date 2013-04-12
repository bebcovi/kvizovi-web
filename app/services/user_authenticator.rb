require "bcrypt"

class UserAuthenticator
  def initialize(user_class)
    @user_class = user_class
  end

  def authenticate(username, password)
    user = @user_class.find_by_username(username)

    return nil if user.nil?

    if BCrypt::Password.new(user.password_digest) == password
      user
    else
      false
    end
  end
end
