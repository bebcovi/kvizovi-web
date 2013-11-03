class SurveysController < ApplicationController
  before_filter :authenticate_user!

  def new
    @survey = Survey.new
  end

  def create
    @survey = Survey.new
    @survey.assign_attributes(survey_params)

    if @survey.valid?
      @survey.save
      current_user.update_column(:completed_survey, true)
      redirect_to account_path, success: flash_success
    else
      set_flash_error
      render :new
    end
  end

  private

  def survey_params
    params.require(:survey).permit!
  end
end
