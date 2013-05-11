class HomeController < ApplicationController
  before_filter :redirect_if_logged_in

  def index
  end

  private

  def redirect_if_logged_in
    if user_logged_in?
      redirect_to root_url(subdomain: current_user.type)
    end
  end
end
