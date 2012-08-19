class SchoolsController < ApplicationController
  def new
    @school = School.new
  end

  def show
    @school = current_school
  end
end
