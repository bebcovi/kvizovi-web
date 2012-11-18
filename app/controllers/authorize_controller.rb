class AuthorizeController < ApplicationController
  def show
    render :authorize
  end

  def authorize
    if params[:secret_key] == ENV["LEKTIRE_KEY"]
      flash[:authorized] = true
      redirect_to new_school_path, notice: flash_message(:notice)
    else
      flash.now[:alert] = flash_message(:alert)
    end
  end
end
