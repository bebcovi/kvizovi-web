require "spec_helper"

describe SurveysController, user: :school do
  before do
    @user = FactoryGirl.create(:school)
    login_as(@user)
  end

  describe "#new" do
    it "doesn't raise errors" do
      get :new
    end
  end

  describe "#create" do
    it "marks that the user has completed the survey" do
      expect do
        post :create
      end.to change{@user.reload.completed_survey?}.to(true)
    end

    it "redirect the user back to the home page" do
      post :create
      expect(response).to redirect_to(controller.send(:root_path_for, @user))
    end
  end
end
