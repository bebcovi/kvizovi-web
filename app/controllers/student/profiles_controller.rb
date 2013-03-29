class Student::ProfilesController < Student::BaseController
  before_filter :authenticate!

  def show
    @student = current_user
  end

  def edit
    @student = current_user
  end

  def update
    @student = current_user
    @student.assign_attributes(params[:student])

    if @student.valid?
      @student.save
      redirect_to profile_path, notice: flash_message(:notice)
    else
      render :edit
    end
  end
end
