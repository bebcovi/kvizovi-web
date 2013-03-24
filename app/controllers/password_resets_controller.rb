class PasswordResetsController < ApplicationController
  def new
  end

  def create
    if user = user_class.find_by_email(params[:email])
      PasswordResetter.new(user).reset_password
      PasswordSender.password(user).deliver
      redirect_to login_path(type: params[:type]), notice: flash_message(:notice)
    else
      set_alert_message
      render :new
    end
  end

  private

  def user_class
    params[:type].camelize.constantize
  end
end
