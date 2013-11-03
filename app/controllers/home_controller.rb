class HomeController < ApplicationController
  before_filter { redirect_to account_path if user_logged_in? }

  def index
  end
end
