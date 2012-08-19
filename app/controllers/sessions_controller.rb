# encoding: utf-8

class SessionsController < ApplicationController
  def new_student
    @regions = Region.all
  end

  def new_school
  end

  def create
    if params[:student]
      student = School.find(params[:school_id]).students.authenticate(params[:student])

      if student
        log_in!(student)
        redirect_to new_game_path
      else
        flash.now[:alert] = "Pogrešno korisničko ime ili lozinka."
        render :new_student
      end
    else
      school = School.authenticate(params[:school])

      if school
        log_in!(school)
        redirect_to school
      else
        render :new_school
      end
    end
  end

  def destroy
    log_out!
    redirect_to root_path
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
