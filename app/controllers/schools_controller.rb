# encoding: utf-8

class SchoolsController < ApplicationController
  def new
    if flash[:authorized]
      @school = School.new
    else
      redirect_to authorize_path
    end
  end

  def create
    @school = School.new(params[:school])

    if @school.save
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

  def destroy
    current_school.destroy
    log_out!
    redirect_to root_path, notice: "Vaš profil je uspješno izbrisan."
  end
end
