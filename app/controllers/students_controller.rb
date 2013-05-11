class StudentsController < ApplicationController
  before_filter :authenticate!
  before_filter :assign_school

  def index
    @students = @school.students
  end

  private

  def assign_school
    @school = current_user
  end
end
