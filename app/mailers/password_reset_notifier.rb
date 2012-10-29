class PasswordResetNotifier < ActionMailer::Base
  default from: "Lektire <#{ENV["SENDGRID_USERNAME"]}>"

  def password_reset(user, new_password)
    @user = user
    @new_password = new_password
    mail(subject: "Nova lozinka", to: @user.email)
  end
end
