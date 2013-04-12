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
      it "assigns quiz's questions" do
        quiz_question = Factory.create_without_validation(:empty_question)
        quiz_question.quizzes << @quiz
        other_questions = Factory.create_without_validation(:empty_question)
        get :index, quiz_id: @quiz.id
        expect(assigns(:questions)).to eq [quiz_question]
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
      @question = Factory.create_without_validation(:empty_question)
      @question.quizzes << @quiz
    end

    describe "#show" do
      it "doesn't raise errors" do
        get :show, quiz_id: @quiz.id, id: @question.id
      end
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

    describe "#delete" do
      it "doesn't raise errors" do
        get :delete, quiz_id: @quiz.id, id: @question.id
      end
    end

    describe "#destroy" do
      it "scopes to current quiz" do
        other_quiz = Factory.create_without_validation(:empty_quiz)
        expect {
          delete :destroy, quiz_id: other_quiz.id, id: @question.id
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "destroyes the record" do
        delete :destroy, quiz_id: @quiz.id, id: @question.id
        expect(@quiz.questions.exists?(@question)).to be_false
      end
    end

    describe "#remove" do
      it "removes the question from quiz" do
        delete :remove, quiz_id: @quiz.id, id: @question.id
        expect(@quiz.questions.exists?(@question)).to be_false
      end

      it "doesn't delete the record" do
        delete :remove, quiz_id: @quiz.id, id: @question.id
        expect(Question.exists?(@question)).to be_true
      end
    end
  end
end
