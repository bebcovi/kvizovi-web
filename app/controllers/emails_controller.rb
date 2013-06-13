class EmailsController < ApplicationController
  before_filter :authenticate!
  before_filter :load_user

  def new
  end

  def create
    @user.assign_attributes(user_params)

    if @user.valid?
      @user.save
      redirect_to root_path_for(@user)
    else
      render :new
    end
  end

  private

  def load_user
    @user = current_user
  end

  def user_params
    params.require(@user.type).permit(:email)
  end
end
