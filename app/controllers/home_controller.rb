class HomeController < ApplicationController
  before_action { redirect_to account_path if user_logged_in? }

  def index
  end
end
