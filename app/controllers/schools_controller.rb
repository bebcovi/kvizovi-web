class SchoolsController < ApplicationController
  around_filter :respond_with_json, only: [:index, :show]

  def index
    @schools = School.all
    render json: @schools
  end

  def show
    @school = School.find(params[:id])
    render json: @school
  end

  def create
    School.create(params[:school])
  end

  def update
    School.find(params[:id]).update_attributes(params[:school])
  end

  def destroy
    School.destroy(params[:id])
  end
end
