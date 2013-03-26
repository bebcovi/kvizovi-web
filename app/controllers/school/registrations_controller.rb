class School::RegistrationsController < School::BaseController
  before_filter :authorize, only: :new

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

  private

  def authorize
    if not flash[:authorized]
      redirect_to new_authorization_path
    end
  end
end
