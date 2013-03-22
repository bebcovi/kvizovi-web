class SessionsController < ApplicationController
  def new
    @login = Login.new
  end

  def create
    @login = Login.new(params[:login])
    @login.user_class = user_class

    if @login.valid?
      log_in!(@login.user, permanent: @login.remember_me?)
      redirect_to root_path
    else
      set_alert_message
      render :new
    end
  end

  def destroy
    log_out!
    redirect_to root_path
  end

  private

  def user_class
    params[:type].camelize.constantize
  end
end
