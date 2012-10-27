class AdminController < ApplicationController
  def index
    @schools = School.scoped
    @students = Student.scoped.includes(:school)
  end

  def school
    @school = School.find(params[:id])
  end
end
