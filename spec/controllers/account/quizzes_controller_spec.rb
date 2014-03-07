require "spec_helper"

describe Account::QuizzesController do
  before { login_as(:school) }
  let!(:quiz) { create(:quiz, school: current_user) }

  describe "#edit" do
    it "authorizes the user" do
      expect(controller).to receive(:authorize_user!)
      get :edit, id: quiz.id
    end
  end

  describe "#update" do
    it "authorizes the user" do
      expect(controller).to receive(:authorize_user!)
      put :update, id: quiz.id, quiz: {}
    end
  end

  describe "#destroy" do
    it "authorizes the user" do
      expect(controller).to receive(:authorize_user!)
      delete :destroy, id: quiz.id
    end
  end

  describe "#authorize_user!" do
    it "succeeds when the quiz belongs to the user" do
      get :edit, id: quiz.id
      expect(response).to be_a_success
    end

    it "fails when the quiz doesn't belong to the user" do
      quiz.update(school_id: current_user.id + 1)
      get :edit, id: quiz.id
      expect(response).to be_a_redirect
    end
  end
end
