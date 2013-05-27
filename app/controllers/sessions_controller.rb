class SessionsController < ApplicationController
  def new
    @login = Login.new
  end

  def create
    @login = Login.new(params[:login])
    @login.user_class = user_class

    if @login.valid?
      log_in!(@login.user)
      redirect_to return_point
    else
      set_flash_error
      render :new
    end
  end

  def destroy
    log_out!
    redirect_to root_url(subdomain: false)
  end
end
