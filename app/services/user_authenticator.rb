class UserAuthenticator
  def initialize(user)
    @user = user
  end

  def authenticate(password)
    @user.try(:authenticate, password)
  end
end
