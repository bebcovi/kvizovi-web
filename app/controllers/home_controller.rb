class HomeController < ApplicationController
  def index
    if user_logged_in?
      if current_user.is_a?(School)
        redirect_to quizzes_path
      else
        redirect_to new_game_path
      end
    else
      render
    end
  end
end
