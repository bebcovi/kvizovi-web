class ApplicationController < ActionController::Base
  def current_school
    @current_school ||= School.find(cookies[:school_id])
  end
  helper_method :current_school

  def school_logged_in?
    cookies[:school_id].present?
  end
  helper_method :school_logged_in?

  def authenticate!
    if not school_logged_in?
      redirect_to new_game_path
    end
  end
end
