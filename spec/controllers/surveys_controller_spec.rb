require "spec_helper"

describe SurveysController, user: :school do
  before do
    @user = FactoryGirl.create(:school)
    sign_in(@user)
  end

  describe "#create" do
    it "marks that the user has completed the survey" do
      post :create, survey: {fields_attributes: {}}
      expect(@user.reload.completed_survey?).to eq true
    end
  end
end
