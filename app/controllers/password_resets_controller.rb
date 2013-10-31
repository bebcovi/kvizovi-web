class PasswordResetsController < ApplicationController
  def new
  end

  def confirm
    if user = user_class.find_by_email(params[:email])
      PasswordResetService.new(user).generate_confirmation_id
      PasswordResetMailer.confirmation(user).deliver
      redirect_to login_path, success: flash_success
    else
      set_flash_error
      render :new
    end
  end

  def create
    if user = user_class.find_by_email(params[:email]) and
       user.password_reset_confirmation_id == params[:confirmation_id]

      PasswordResetService.new(user).reset_password
      PasswordResetMailer.new_password(user).deliver
      redirect_to login_path, success: flash_success
    else
      redirect_to login_path, error: flash_error
    end
  end
end
