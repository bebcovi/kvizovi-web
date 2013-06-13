class ProfilesController < ApplicationController
  before_filter :authenticate!

  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    @user.assign_attributes(user_params)

    if @user.valid?
      @user.save
      redirect_to profile_path, notice: flash_success
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(@user.type).permit(*user_attributes)
  end

  def user_attributes
    send("#{current_user.type}_attributes")
  end

  def student_attributes
    [:first_name, :last_name, :gender, :year_of_birth, :grade, :username, :email]
  end

  def school_attributes
    [:name, :username, :email, :level, :place, :region, :key]
  end
end
