class Student::RegistrationsController < Student::BaseController
  before_filter :authenticate!, only: [:delete, :destroy]

  def new
    @student = Student.new
  end

  def create
    @student = Student.new(params[:student])

    if @student.valid?
      @student.save
      log_in!(@student)
      redirect_to root_path, notice: flash_message(:notice)
    else
      render :new
    end
  end

  def delete
    @student = current_user
  end

  def destroy
    @student = current_user

    if @student.authenticate(params[:password])
      @student.destroy
      log_out!
      redirect_to root_url(subdomain: false), notice: flash_message(:notice)
    else
      set_alert_message
      render :delete
    end
  end
end
