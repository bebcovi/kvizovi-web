class ApplicationController < ActionController::Base
  private

  def current_student() @current_student ||= Student.find(cookies[:student_id]) end
  def student_logged_in?() cookies[:student_id].present? end
  def authenticate_student!() redirect_to root_path if not student_logged_in? end
  helper_method :current_student, :student_logged_in?

  def current_school() @current_school ||= School.find(cookies[:school_id]) end
  def school_logged_in?() cookies[:school_id].present? end
  def authenticate_school!() redirect_to root_path if not school_logged_in? end
  helper_method :current_school, :school_logged_in?

  def current_user
    if student_logged_in?
      @current_user ||= current_student
    elsif school_logged_in?
      @current_user ||= current_school
    end
  end
  helper_method :current_user

  def logged_in?
    cookies[:student_id].present? or cookies[:school_id].present?
  end
  helper_method :logged_in?

  def authenticate!
    redirect_to root_path if not logged_in?
  end

  def log_in!(user)
    name = user.class.name.underscore
    if params[:remember_me]
      cookies.permanent[:"#{name}_id"] = user.id
    else
      cookies[:"#{name}_id"] = user.id
    end
  end

  def log_out!
    cookies.delete(:school_id)
    cookies.delete(:student_id)
  end
end
