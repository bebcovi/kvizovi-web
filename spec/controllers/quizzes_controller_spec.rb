require "spec_helper"

describe QuizzesController do
  before(:all) { @school = create(:school) }

  before do
    request.host = "school.example.com"
    controller.send(:log_in!, @school)
  end

  context "collection" do
    describe "#index" do
      it "assigns school's quizzes" do
        school_quiz = create(:quiz, school: @school)
        other_quiz  = create(:quiz)
        get :index
        expect(assigns(:quizzes)).to eq [school_quiz]
      end
    end

    describe "#new"
    describe "#create"
  end

  context "member" do
    before(:all) { @quiz = create(:quiz, school: @school) }

    describe "#edit"

    describe "#update" do
      it "scopes to current user" do
        other_quiz = create(:quiz)
        expect {
          post :update, id: other_quiz.id
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    describe "#toggle_activation" do
      context "when quiz is activated" do
        before { @quiz.update_column(:activated, true) }

        it "deactivates the quiz" do
          expect {
            put :toggle_activation, id: @quiz.id
          }.to change{@quiz.reload.activated?}.to(false)
        end
      end

      context "when quiz is not activated" do
        before { @quiz.update_column(:activated, false) }

        it "activates the quiz" do
          expect {
            put :toggle_activation, id: @quiz.id
          }.to change{@quiz.reload.activated?}.to(true)
        end
      end
    end

    describe "#destroy" do
      it "scopes to current user" do
        other_quiz = create(:quiz)
        expect {
          delete :destroy, id: other_quiz.id
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    after(:all) { @quiz.destroy }
  end

  after(:all) { @school.destroy }
end
