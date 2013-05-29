class PasswordResetMailer < ActionMailer::Base
  default from: "Lektire <#{ENV["SENDGRID_USERNAME"]}>"

  def mail(*)
    prepend_view_path "app/views/#{@user.type}"
    super
  end

  def new_password(user, email)
    @user = user
    to = email
    mail(subject: "Nova lozinka", to: to)
  end

  def confirmation(user, email)
    @user = user
    @email = email
    to = @user.is_a?(School) ? @user.email : @user.school.email
    mail(subject: "Potvrda za novu lozinku", to: to)
  end
end
