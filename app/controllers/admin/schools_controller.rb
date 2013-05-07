class Admin::SchoolsController < ApplicationController
  def index
    @schools = School.scoped
    @students = Student.scoped.includes(:school)
  end

  def show
    @school = School.find(params[:id])
  end
end
