class HomeController < ApplicationController
  before_filter :redirect_if_user_logged_in

  def index
  end

  private

  def redirect_if_user_logged_in
    if current_user.is_a?(School)
      redirect_to quizzes_path
    elsif current_user.is_a?(Student)
      redirect_to new_game_path
    end
  end
end
