class Account::StudentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :assign_school

  def index
    @students = @school.students
  end

  private

  def assign_school
    @school = current_user
  end
end
