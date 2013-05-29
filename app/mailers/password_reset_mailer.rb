class PasswordResetMailer < ActionMailer::Base
  default from: "Lektire <#{ENV["SENDGRID_USERNAME"]}>"

  def new_password(user)
    @user = user
    mail(subject: "Nova lozinka", to: @user.email)
  end

  def confirmation(user)
    @user = user
    mail(subject: "Potvrda za novu lozinku", to: @user.email)
  end
end
