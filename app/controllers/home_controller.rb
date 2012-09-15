class HomeController < ApplicationController
  def index
    if school_logged_in?
      redirect_to quizzes_path
    elsif student_logged_in?
      redirect_to new_game_path
    end
  end
end
