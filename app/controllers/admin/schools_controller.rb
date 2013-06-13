class Admin::SchoolsController < ApplicationController
  def index
    @schools = School.all
    @students = Student.includes(:school)
  end

  def show
    @school = School.find(params[:id])
  end
end
