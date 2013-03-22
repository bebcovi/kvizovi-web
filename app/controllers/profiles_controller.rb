class ProfilesController < ApplicationController
  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    @user.assign_attributes(user_params)

    if @user.valid?
      @user.save
      redirect_to profile_path, notice: flash_message(:notice)
    else
      render :edit
    end
  end

  def delete
  end

  def destroy
    if current_user.authenticate(params[:password])
      current_user.destroy
      log_out!
      redirect_to root_path, notice: flash_message(:notice)
    else
      set_alert_message
      render :delete
    end
  end

  private

  def user_params
    params[current_user.type]
  end
end
