class AdminController < ApplicationController
  def index
    redirect_to admin_schools_path
  end

  def schools
    @schools = School.scoped
  end

  def students
    @students = School.find(params[:school_id]).students
  end

  def quizzes
    @quizzes = School.find(params[:school_id]).quizzes
  end
end
