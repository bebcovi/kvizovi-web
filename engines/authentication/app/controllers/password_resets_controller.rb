class PasswordResetsController < AuthenticationController
  def new
  end

  def create
    if user = user_class.find_by_email(params[:email])
      PasswordResetter.new(user).reset_password
      PasswordSender.password(user).deliver
      redirect_to login_path, notice: flash_success
    else
      set_flash_error
      render :new
    end
  end
end
