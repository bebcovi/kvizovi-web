class PasswordResetMailer < ActionMailer::Base
  default from: "Kvizovi <#{ENV["SENDGRID_USERNAME"]}>"

  def mail(*)
    prepend_view_path "app/views/#{@user.type}"
    super
  end

  def new_password(user)
    @user = user
    mail(subject: "Nova lozinka", to: @user.email)
  end

  def confirmation(user)
    @user = user
    mail(subject: "Potvrda za novu lozinku", to: @user.email)
  end
end
