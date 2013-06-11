class ProfilesController < ApplicationController
  before_filter :authenticate!

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
      redirect_to profile_path, notice: flash_success
    else
      render :edit
    end
  end

  private

  def user_params
    params[@user.type]
  end
end
