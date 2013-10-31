class PasswordsController < ApplicationController
  before_filter :authenticate!

  def edit
    @password = Password.new
  end

  def update
    @password = Password.new(params[:password])
    @password.user = current_user

    if @password.valid?
      current_user.update_attributes(password: @password.new, password_confirmation: @password.new)
      redirect_to profile_path, success: flash_success
    else
      render :edit
    end
  end
end
