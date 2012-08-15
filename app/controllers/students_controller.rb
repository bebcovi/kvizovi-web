# encoding: utf-8

class StudentsController < ApplicationController
  before_filter :authenticate!

  def index
    @students = current_school.students
  end

  def new
    @student = current_school.students.new
  end

  def create
    @student = current_school.students.create(params[:student])

    if @student.valid?
      redirect_to students_path, notice: "Učenik \"#{@student.name}\" je uspješno dodan."
    else
      flash.now[:alert] = "Neka polja nisu ispravno popunjena."
      render :new
    end
  end

  def show
    @student = current_school.students.find(params[:id])
  end

  def edit
    @student = current_school.students.find(params[:id])
  end

  def update
    @student = current_school.students.find(params[:id])

    if @student.update_attributes(params[:student])
      redirect_to students_path, notice: "Učenik \"#{@student.name}\" je uspješno izmijenjen."
    else
      flash.now[:alert] = "Neka polja nisu ispravno popunjena."
      render :edit
    end
  end

  def destroy
    current_school.students.destroy(params[:id])
    redirect_to students_path
  end
end
