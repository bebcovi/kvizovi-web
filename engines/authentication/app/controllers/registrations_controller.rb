class RegistrationsController < AuthenticationController
  before_filter :authorize_if_school, only: :new
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
      redirect_to root_path, notice: flash_success
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

  def authorize_if_school
    school do
      if not flash[:authorized]
        redirect_to new_authorization_path
      end
    end
  end

  def perform_callbacks(user)
    school  { ExampleQuizzesCreator.new(user).create }
    student {}
  end

  def user_params
    school  { return params[:school] }
    student { return params[:student] }
  end
end
