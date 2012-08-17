class SchoolsController < ApplicationController
  before_filter :authenticate_user!

  def show
    @school = School.find(params[:id])
  end
end
