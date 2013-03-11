class SessionsController < ApplicationController
  def new
    if params[:type]
      @login = Login.new
    else
      redirect_to root_path
    end
  end

  def create
    @login = Login.new(params[:login])
    if user = @login.authenticate(params[:type])
      log_in!(user, permanent: @login.remember_me?)
      redirect_to root_path
    else
      flash.now[:alert] = flash_message(:alert)
      render :new
    end
  end

  def destroy
    log_out!
    redirect_to root_path
  end
end
