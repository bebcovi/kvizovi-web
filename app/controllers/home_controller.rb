class HomeController < ApplicationController
  before_filter do
    redirect_to root_path_for(current_user) if user_logged_in?
  end

  def index
  end
end
