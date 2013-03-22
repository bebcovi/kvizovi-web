class ErrorsController < ApplicationController
  def show
    render status_code.to_s, status: status_code
  end

  private

  def status_code
    params[:code].to_i
  end
end
