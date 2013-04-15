require "spec_helper"

describe QuestionsController do
  school!

  before do
    @user = Factory.create_without_validation(:empty_school)
    controller.send(:log_in!, @user)
    @quiz = Factory.create_without_validation(:empty_quiz, school: @user)
  end

  context "collection" do
    describe "#index" do
      it "doesn't raise errors" do
        get :index, quiz_id: @quiz.id
      end
    end

    describe "#new" do
      it "assigns the right type of question" do
        get :new, quiz_id: @quiz.id, category: "boolean"
        expect(assigns(:question)).to be_a_new(BooleanQuestion)
      end
    end

    describe "#create" do
      it "scopes to current quiz" do
        other_quiz = Factory.create_without_validation(:empty_quiz)
        expect {
          post :create, quiz_id: other_quiz.id, category: "boolean"
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

      context "when valid" do
        before do
          BooleanQuestion.any_instance.stub(:valid?) { true }
        end

        it "creates the question" do
          expect {
            post :create, quiz_id: @quiz.id, category: "boolean"
          }.to change { @quiz.questions.count }.by 1
          expect(@quiz.questions.first).to be_a(BooleanQuestion)
        end
      end

      context "when invalid" do
        before do
          BooleanQuestion.any_instance.stub(:valid?) { false }
        end

        it "doesn't raise errors" do
          post :create, quiz_id: @quiz.id, category: "boolean"
        end
      end
    end
  end

  context "member" do
    before do
      @question = Factory.create_without_validation(:empty_question, quiz: @quiz)
    end

    describe "#edit" do
      it "doesn't raise errors" do
        get :edit, quiz_id: @quiz.id, id: @question.id
      end
    end

    describe "#update" do
      it "scopes to current quiz" do
        other_quiz = Factory.create_without_validation(:empty_quiz)
        expect {
          put :update, quiz_id: other_quiz.id, id: @question.id, category: "boolean"
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

      context "when valid" do
        before do
          @question.class.any_instance.stub(:valid?) { true }
        end

        it "updates the record" do
          put :update, quiz_id: @quiz.id, id: @question.id, boolean_question: {content: "New content"}, category: "boolean"
          expect(@question.reload.content).to eq "New content"
        end
      end

      context "when not valid" do
        before do
          @question.class.any_instance.stub(:valid?) { false }
        end

        it "doesn't raise errors" do
          put :update, quiz_id: @quiz.id, id: @question.id, category: "boolean"
        end
      end
    end

    describe "#destroy" do
      it "destroyes the question" do
        delete :destroy, quiz_id: @quiz.id, id: @question.id
        expect(Question.exists?(@quesion)).to be_false
      end
    end
  end
end
