require "spec_helper"

describe Account::QuestionsController do
  before { login_as(:school) }
  let!(:quiz) { create(:quiz, school: current_user) }
  let(:question) { create(:question, quiz: quiz) }

  describe "#index" do
    it "authorizes the user" do
      expect(controller).to receive(:authorize_user!)
      get :index, quiz_id: quiz.id
    end
  end

  describe "#edit" do
    it "authorizes the user" do
      expect(controller).to receive(:authorize_user!)
      get :edit, quiz_id: quiz.id, id: question.id
    end
  end

  describe "#update" do
    it "authorizes the user" do
      expect(controller).to receive(:authorize_user!)
      put :update, quiz_id: quiz.id, id: question.id
    end
  end

  describe "#destroy" do
    it "authorizes the user" do
      expect(controller).to receive(:authorize_user!)
      delete :destroy, quiz_id: quiz.id, id: question.id
    end
  end

  describe "#edit_order" do
    it "authorizes the user" do
      expect(controller).to receive(:authorize_user!)
      get :edit_order, quiz_id: quiz.id
    end
  end

  describe "#update_order" do
    it "authorizes the user" do
      expect(controller).to receive(:authorize_user!)
      put :update_order, quiz_id: quiz.id, quiz: {name: quiz.name}
    end
  end

  describe "#authorize_user!" do
    it "succeeds when the quiz belongs to the user" do
      get :edit, quiz_id: quiz.id, id: question.id
      expect(response).to be_a_success
    end

    it "fails when the quiz doesn't belong to the user" do
      quiz.update(school_id: current_user.id + 1)
      get :edit, quiz_id: quiz.id, id: question.id
      expect(response).to be_a_redirect
    end
  end
end
