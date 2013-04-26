require "spec_helper"

describe SurveyController, user: :school do
  before do
    @user = Factory.create(:user)
    login_as(@user)
  end

  describe "#show" do
    it "doesn't raise errors" do
      get :show
    end
  end

  describe "#complete" do
    it "marks that the user has completed the survey" do
      expect do
        post :complete
      end.to change { @user.reload.completed_survey? }.from(false).to(true)
    end

    it "redirect the user back to the home page" do
      post :complete
      expect(response).to redirect_to(root_path)
    end
  end
end
