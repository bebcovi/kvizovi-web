class StudentsController < ApplicationController
  def index
    school = current_user
    @students = school.students
  end

  def new
    @student = Student.new
  end

  def create
    @student = Student.new(params[:student])

    if @student.valid?
      @student.save
      log_in!(@student)
      redirect_to new_game_path, notice: flash_message(:notice)
    else
      render :new
    end
  end

  def show
    @student = current_user
  end

  def edit
    @student = current_user
  end

  def update
    @student = current_user

    if @student.update_attributes(params[:student])
      redirect_to @student, notice: flash_message(:notice)
    else
      render :edit
    end
  end

  def new_password
    school = current_user
    @student = school.students.find(params[:id])
  end

  def change_password
    school = current_user
    @student = school.students.find(params[:id])

    if @student.update_attributes(params[:student])
      redirect_to students_path, notice: flash_message(:notice)
    else
      render :new_password
    end
  end

  def delete
    @student = if current_user.is_a?(School)
                 current_user.students.find(params[:id])
               else
                 current_user
               end
  end

  def destroy
    if current_user.is_a?(School)
      school = current_user
      school.students.destroy(params[:id])
      redirect_to students_path, notice: flash_message(:notice, "school_destroy")
    else
      @student = current_user
      if @student.authenticate(params[:student][:password])
        @student.destroy
        log_out!
        redirect_to root_path, notice: flash_message(:notice)
      else
        flash.now[:alert] = flash_message(:alert)
        render :delete
      end
    end
  end
end
