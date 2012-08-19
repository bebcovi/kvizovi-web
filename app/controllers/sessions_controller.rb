# encoding: utf-8

class SessionsController < ApplicationController
  def new
    if student_logged_in?
      redirect_to new_game_path
    elsif school_logged_in?
      redirect_to current_school
    end
  end

  def create
    user = User.authenticate(params[:user])

    if user
      log_in!(user)
      redirect_to root_path
    else
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
