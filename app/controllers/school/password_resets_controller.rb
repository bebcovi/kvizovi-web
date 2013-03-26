class School::PasswordResetsController < School::BaseController
  def new
  end

  def create
    if school = School.find_by_email(params[:email])
      PasswordResetter.new(school).reset_password
      PasswordSender.password(school).deliver
      redirect_to login_path, notice: flash_message(:notice)
    else
      set_alert_message
      render :new
    end
  end
end

