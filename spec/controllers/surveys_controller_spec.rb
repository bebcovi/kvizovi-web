require "spec_helper"

describe SurveysController do
  before { login_as(:school) }

  describe "#create" do
    it "marks that the user has completed the survey" do
      post :create, survey: {fields_attributes: {}}
      expect(current_user.reload.completed_survey?).to eq true
    end
  end
end
