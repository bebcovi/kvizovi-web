class SchoolsController < ApplicationController
  def index
    @schools = School.all

    respond_to do |format|
      format.json { render json: @schools }
    end
  end

  def show
    @school = School.find(params[:id])

    respond_to do |format|
      format.json { render json: @school }
    end
  end

  def create
    school = School.create(params[:school])
    head :created, location: school_path(school)
  end

  def update
    School.find(params[:id]).update_attributes(params[:school])
    head :ok
  end

  def destroy
    School.destroy(params[:id])
    head :ok
  end
end
