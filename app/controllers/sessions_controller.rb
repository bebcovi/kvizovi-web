# encoding: utf-8

class SessionsController < ApplicationController
  def new
  end

  def create
    if school = School.authenticate(params[:school])
      log_in!(school)
      redirect_to root_path
    else
      flash.now[:alert] = "Pogrešno korisničko ime ili lozinka."
      render :new
    end
  end

  def destroy
    log_out!
    redirect_to :back
  end

  private

  def log_in!(school)
    cookies[:school_id] = {value: school.id, expires: 1.day.from_now}
  end

  def log_out!
    cookies.delete(:school_id)
  end
end
