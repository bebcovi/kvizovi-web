class SurveysController < InheritedResources::Base
  before_action :authenticate_user!

  def create
    super do |success, failure|
      success.html do
        current_user.update_column(:completed_survey, true)
        redirect_to account_path, success: "Anketa je uspješno poslana. Hvala na pomoći :)"
      end
    end
  end

  private

  def permitted_params
    params.permit!
  end
end
