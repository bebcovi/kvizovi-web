class PasswordSender < ActionMailer::Base
  default from: "Lektire <#{ENV["SENDGRID_USERNAME"]}>"

  def password(user)
    @user = user
    mail(subject: "Nova lozinka", to: @user.email)
  end
end
