class SurveyController < ApplicationController
  before_filter :authenticate!

  def show
  end

  def complete
    current_user.update_attributes(completed_survey: true)
    redirect_to root_path, notice: flash_success
  end
end
