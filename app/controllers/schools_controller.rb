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
