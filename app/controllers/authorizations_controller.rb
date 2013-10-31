class AuthorizationsController < ApplicationController
  def new
  end

  def create
    if params[:secret_key] == ENV["SECRET_KEY"]
      flash[:authorized] = true
      redirect_to new_registration_path, success: flash_success
    else
      render :new
    end
  end
end
