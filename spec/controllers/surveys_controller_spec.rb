require "spec_helper"

describe SurveysController, user: :school do
  before do
    @user = FactoryGirl.create(:school)
    sign_in(@user)
  end

  describe "#new" do
    it "doesn't raise errors" do
      get :new
    end
  end

  describe "#create" do
    it "marks that the user has completed the survey" do
      expect do
        post :create, survey: {fields_attributes: {}}
      end.to change{@user.reload.completed_survey?}.to(true)
    end

    it "redirect the user back to the home page" do
      post :create, survey: {fields_attributes: {}}
      expect(response).to redirect_to(account_path)
    end
  end
end
