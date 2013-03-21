class UserAuthenticator
  def initialize(user_class)
    @user_class = user_class
  end

  def authenticate(credentials)
    user = @user_class.where(username: credentials[:username]).first
    user.try(:authenticate, credentials[:password])
  end
end
