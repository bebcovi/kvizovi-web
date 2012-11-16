# encoding: utf-8

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

    if @student.save
      log_in!(@student)
      redirect_to new_game_path, notice: notice
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
      redirect_to @student, notice: notice
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
      redirect_to students_path, notice: notice
    else
      render :new_password
    end
  end

  def delete
    @student = current_user
  end

  def destroy
    if current_user.is_a?(School)
      school = current_user
      school.students.destroy(params[:id])
      redirect_to students_path, notice: notice("school_destroy")
    else
      @student = current_user
      if @student.authenticate(params[:student][:password])
        @student.destroy
        log_out!
        redirect_to root_path, notice: notice
      else
        flash.now[:alert] = alert
        render :delete
      end
    end
  end
end
