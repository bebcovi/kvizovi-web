class RegistrationsController < ApplicationController
  before_filter :authorize, only: :new
  before_filter :authenticate!, only: [:delete, :destroy]

  def new
    @user = user_class.new
  end

  def create
    @user = user_class.new(user_params)

    if @user.valid?
      @user.save
      perform_callbacks(@user)
      log_in!(@user)
      redirect_to root_path_for(current_user), notice: flash_success
    else
      render :new
    end
  end

  def delete
    @user = current_user
  end

  def destroy
    @user = current_user

    if @user.authenticate(params[:password])
      @user.destroy
      log_out!
      redirect_to root_url(subdomain: false), notice: flash_success
    else
      set_flash_error
      render :delete
    end
  end

  private

  def authorize
    if request.subdomain == "school"
      if not flash[:authorized]
        redirect_to new_authorization_path
      end
    end
  end

  def perform_callbacks(user)
    if user.is_a?(School)
      ExampleQuizzesCreator.new(user).create
    end
  end

  def user_params
    params.require(request.subdomain).permit(*user_attributes)
  end

  def user_attributes
    send("#{request.subdomain}_attributes")
  end

  def student_attributes
    [:first_name, :last_name, :gender, :year_of_birth, :email, :username, :password, :password_confirmation, :grade, :school_key]
  end

  def school_attributes
    [:name, :level, :place, :region, :email, :username, :password, :password_confirmation, :key]
  end
end
