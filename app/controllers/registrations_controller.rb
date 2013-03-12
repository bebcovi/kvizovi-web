class RegistrationsController < ApplicationController
  before_filter :authorize, only: :new

  def new
    @user = user_class.new
  end

  def create
    @user = user_class.new(user_params)

    if @user.valid?
      RegistrationCallbacks.new(@user).save
      log_in!(@user)
      redirect_to root_path, notice: flash_message(:notice)
    else
      render :new
    end
  end

  private

  def authorize
    if params[:type] == "school" and not flash[:authorized]
      redirect_to new_authorization_path
    end
  end

  def user_class
    params[:type].camelize.constantize
  end

  def user_params
    params[:school] || params[:student]
  end

  def default_url_options(options = {})
    params[:type] ? {type: params[:type]} : {}
  end
end
