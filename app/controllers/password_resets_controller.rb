class PasswordResetsController < ApplicationController
  def new
  end

  def confirm
    if user = case
              when school?  then School.find_by_email(params[:email])
              when student? then Student.find_by_username(params[:username])
              end \
       and not (student? and params[:email].blank?)

      PasswordResetService.new(user).generate_confirmation_id
      PasswordResetMailer.confirmation(user, params[:email]).deliver
      redirect_to login_path, notice: flash_success
    else
      set_flash_error
      render :new
    end
  end

  def create
    if user = case
              when school?  then School.find_by_email(params[:email])
              when student? then Student.find_by_username(params[:username])
              end \
       and user.password_reset_confirmation_id == params[:confirmation_id]

      PasswordResetService.new(user).reset_password
      PasswordResetMailer.new_password(user, params[:email]).deliver
      redirect_to login_path, notice: flash_success
    else
      redirect_to login_path, alert: flash_error
    end
  end
end
