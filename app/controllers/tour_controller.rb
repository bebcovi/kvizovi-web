class TourController < ApplicationController
  before_filter :store_referer, only: :index

  def index
  end

  private

  def store_referer
    if request.referer != tour_url
      cookies[:referer] = request.referer
    end
  end

  def back_link
    cookies[:referer] || root_path
  end
  helper_method :back_link
end
