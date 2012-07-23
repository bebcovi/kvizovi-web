class StudentsController < ApplicationController
  def index
    @students = Student.all

    respond_to do |format|
      format.json { render json: @students }
    end
  end

  def show
    @student = Student.find(params[:id])

    respond_to do |format|
      format.json { render json: @student }
    end
  end

  def create
    @student = Student.create(params[:student])

    if @student.valid?
      head :created, location: student_path(@student)
    else
      render json: @student.errors, status: :bad_request
    end
  end

  def update
    @student = Student.find(params[:id])

    if @student.update_attributes(params[:student])
      head :ok
    else
      render json: @student.errors, status: :bad_request
    end
  end

  def destroy
    Student.destroy(params[:id])
    head :ok
  end
end
