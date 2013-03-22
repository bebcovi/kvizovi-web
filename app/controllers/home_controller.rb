class HomeController < ApplicationController
  before_filter :redirect_if_user_logged_in

  def index
  end

  private

  def redirect_if_user_logged_in
    case current_user
    when School  then redirect_to quizzes_path
    when Student then redirect_to new_game_path
    end
  end
end
