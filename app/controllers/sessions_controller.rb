# encoding: utf-8

class SessionsController < ApplicationController
  def create
    user =
      if params[:student]
        Student.authenticate(params[:student])
      else
        School.authenticate(params[:school])
      end

    if user
      log_in!(user)
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

  def log_in!(user)
    cookies[:"#{user.class.name.underscore}_id"] = {
      value: user.id,
      expires: 1.day.from_now
    }
  end

  def log_out!
    cookies.delete(:school_id)
    cookies.delete(:student_id)
  end
end
