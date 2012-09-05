# encoding: utf-8

class StudentsController < ApplicationController
  def index
    @students = current_school.students
  end

  def new
    @student = Student.new
  end

  def create
    @student = Student.new(params[:student])

    if @student.save
      log_in!(@student)
      redirect_to new_game_path, notice: "Uspješno ste se registrirali."
    else
      render :new
    end
  end

  def show
    @student = current_student
  end

  def edit
    @student = current_student
  end

  def update
    @student = current_student

    if @student.update_attributes(params[:student])
      redirect_to @student, notice: "Profil je uspješno izmijenjen."
    else
      render :edit
    end
  end

  def destroy
    current_school.students.destroy(params[:id])
    redirect_to students_path, notice: "Učenik je uspješno izbrisan."
  end
end
