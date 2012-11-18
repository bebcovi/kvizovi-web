class AdminController < ApplicationController
  def index
    @schools = School.where("name <> '#{admin_school.name}'")
    @students = Student.where("school_id <> #{admin_school.id}").includes(:school)
  end

  def school
    @school = School.find(params[:id])
  end

  private

  def admin_school
    @admin_school ||= School.find_by_name("Admin")
  end
end
