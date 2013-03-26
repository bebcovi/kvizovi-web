class Student::RegistrationsController < Student::BaseController
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
end
