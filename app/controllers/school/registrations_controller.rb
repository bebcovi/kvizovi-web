class School::RegistrationsController < School::BaseController
  before_filter :authorize, only: :new
  before_filter :authenticate!, only: [:delete, :destroy]

  def new
    @school = School.new
  end

  def create
    @school = School.new(params[:school])

    if @school.valid?
      @school.save
      ExampleQuizzesCreator.new(@school).create
      log_in!(@school)
      redirect_to root_path, notice: flash_message(:notice)
    else
      render :new
    end
  end

  def delete
    @school = current_user
  end

  def destroy
    @school = current_user

    if @school.authenticate(params[:password])
      @school.destroy
      log_out!
      redirect_to root_url(subdomain: false), notice: flash_message(:notice)
    else
      set_alert_message
      render :delete
    end
  end

  private

  def authorize
    if not flash[:authorized]
      redirect_to new_authorization_path
    end
  end
end
