class SessionsController < ApplicationController
  def new
    @session = new_session
    render "new_#{params[:type]}"
  end

  def create
    @session = new_session(params[:user])
    if user = @session.authenticate_user
      log_in!(user, permanent: @session.remember_me?)
      redirect_to root_path
    else
      flash.now[:alert] = flash_message(:alert)
      render "new_#{params[:type]}"
    end
  end

  def destroy
    log_out!
    redirect_to root_path
  end

  private

  def new_session(attributes = {})
    Session.new({type: params[:type]}.merge(attributes))
  end
end
