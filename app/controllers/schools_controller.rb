class SchoolsController < ApplicationController
  def new
    @school = School.new
  end

  def create
    @school = School.new(params[:school])

    if @school.valid?
      @school.create
      log_in!(@school)
      redirect_to @school
    else
      render :new
    end
  end

  def show
    @school = current_school
  end

  def edit
    @school = current_school
  end

  def update
    @school = current_school

    if @school.update_attributes(params[:school])
      redirect_to @school
    else
      render :edit
    end
  end
end
