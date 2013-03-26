class Student::BaseController < ApplicationController
  protected

  def user_logged_in?
    current_user
  end

  def current_user
    if Student.exists?(cookies[:user_id])
      @current_user ||= Student.find(cookies[:user_id])
    end
  end
  helper_method :current_user

  def authenticate!
    if not user_logged_in?
      redirect_to login_path
    end
  end
end
