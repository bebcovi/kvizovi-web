class HomeController < ApplicationController
  def index
    redirect_to account_path if user_logged_in?
  end

  def contact
    params[:contact][:sender] = current_user.email if user_logged_in?

    ContactMailer.contact(params[:contact].symbolize_keys).deliver
  end
end
