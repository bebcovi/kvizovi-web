class SurveysController < ApplicationController
  before_filter :authenticate!

  def new
  end

  def create
    current_user.update_attributes(completed_survey: true)
    redirect_to root_path, notice: flash_success
  end
end
