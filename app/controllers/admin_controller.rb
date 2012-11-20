class AdminController < ApplicationController
  def index
    @schools = (admin_school ? School.where("name <> '#{admin_school.name}'") : School.scoped)
    @students = (admin_school ? Student.where("school_id <> #{admin_school.id}") : Student.scoped).includes(:school)
  end

  def school
    @school = School.find(params[:id])
  end

  private

  def admin_school
    @admin_school ||= School.find_by_name("Admin")
  end

  def sub_layout
    "admin"
  end
end
