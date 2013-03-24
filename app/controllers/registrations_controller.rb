class RegistrationsController < ApplicationController
  before_filter :authorize_if_school, only: :new

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

  def authorize_if_school
    if params[:type] == "school"
      redirect_to new_authorization_path(type: "school") if not flash[:authorized]
    end
  end

  def user_class
    params[:type].camelize.constantize
  end

  def user_params
    params[params[:type]]
  end
end
