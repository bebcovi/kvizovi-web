class SchoolsController < ApplicationController
  def index
    respond_to do |format|
      format.html
      format.json {
        @schools = School.all
        render json: @schools
      }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json {
        @school = School.find(params[:id])
        render json: @school
      }
    end
  end

  def new
    @school = School.new
  end

  def create
    @school = School.create(params[:school])

    if @school.valid?
      head :created, location: school_path(@school)
    else
      render json: @school.errors, status: :bad_request
    end
  end

  def update
    @school = School.find(params[:id])

    if @school.update_attributes(params[:school])
      head :ok
    else
      render json: @school.errors, status: :bad_request
    end
  end

  def destroy
    School.destroy(params[:id])
    head :ok
  end
end
