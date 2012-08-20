# encoding: utf-8

class SessionsController < ApplicationController
  def new_student
  end

  def new_school
  end

  def create
    if params[:student]
      if student = Student.authenticate(params[:student])
        log_in!(student)
        redirect_to new_game_path
      else
        flash.now[:alert] = "Pogrešno korisničko ime ili lozinka."
        render :new_student
      end
    elsif params[:school]
      if school = School.authenticate(params[:school])
        log_in!(school)
        redirect_to school
      else
        flash.now[:alert] = "Pogrešno korisničko ime ili lozinka."
        render :new_school
      end
    end
  end

  def destroy
    log_out!
    redirect_to root_path
  end
end
