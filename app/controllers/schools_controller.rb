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

  def create
    school = School.create(params[:school])
    head :ok, :location => school_path(school)
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
