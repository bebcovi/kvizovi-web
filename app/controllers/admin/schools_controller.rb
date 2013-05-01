class Admin::SchoolsController < ApplicationController
  def index
    @schools = School.scoped
    @students = Student.scoped.includes(:school, :played_quizzes)
  end

  def show
    @school = School.find(params[:id])
  end
end
