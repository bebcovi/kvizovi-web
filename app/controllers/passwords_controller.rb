class PasswordsController < ApplicationController
  def new
  end

  def create
    if school = School.find_by_email(params[:email])
      new_password = PasswordResetter.new(school).reset_password
      PasswordResetNotifier.password_reset(school, new_password).deliver
      redirect_to login_path(type: "school"), notice: flash_message(:notice)
    else
      flash.now[:alert] = flash_message(:alert)
      render :new
    end
  end

  def edit
    @password = Password.new
  end

  def update
    @password = Password.new(params[:password].merge(user: current_user))

    if @password.save
      redirect_to current_user, notice: flash_message(:notice)
    else
      render :edit
    end
  end
end
