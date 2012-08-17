class HomeController < ApplicationController
  def index
    if school_logged_in?
      redirect_to current_school
    elsif student_logged_in?
      redirect_to new_game_path
    end
  end
end
