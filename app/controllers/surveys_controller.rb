class SurveysController < ApplicationController
  before_filter :authenticate!

  def new
    @survey = Survey.new
  end

  def create
    @survey = Survey.new
    @survey.assign_attributes(params[:survey])
    @survey.user = current_user

    if @survey.valid?
      @survey.save
      redirect_to root_path_for(current_user), notice: flash_success
    else
      set_flash_error
      render :new
    end
  end
end
