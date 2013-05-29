require "spec_helper"

describe QuestionsController, user: :school do
  enable_paper_trail

  before do
    @school = Factory.create(:school)
    @quiz = Factory.create(:quiz, school: @school)
    login_as(@school)
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
      context "when valid" do
        before do
          BooleanQuestion.any_instance.stub(:valid?) { true }
        end

        it "creates the question" do
          post :create, quiz_id: @quiz.id, category: "boolean"
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

    describe "#edit_order" do
      it "doesn't raise errors" do
        get :edit_order, quiz_id: @quiz.id
      end
    end

    describe "#update_order" do
      before do
        @quiz.questions = Factory.create_list(:question, 3)
        @questions = @quiz.questions.all
        ActiveRecord::Base.any_instance.stub(:run_validations!) { true }
      end

      it "updates the order of questions" do
        put :update_order, quiz_id: @quiz.id,
          quiz: {
            questions_attributes: {
              0 => {id: @questions[0].id, position: 1},
              1 => {id: @questions[1].id, position: 3},
              2 => {id: @questions[2].id, position: 2},
            }
          }

        expect(@quiz.questions(true)).to eq [@questions[0], @questions[2], @questions[1]]
        expect(@quiz.questions(true).pluck(:position)).to eq [1, 2, 3]
      end
    end
  end

  context "member" do
    before do
      @question = Factory.create(:text_question, quiz: @quiz)
    end

    describe "#edit" do
      it "doesn't raise errors" do
        get :edit, quiz_id: @quiz.id, id: @question.id
      end
    end

    describe "#update" do
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

    describe "#download_location" do
      it "doesn't raise errors" do
        get :download_location, quiz_id: @quiz.id, id: @question.id
      end
    end

    describe "#download" do
      before do
        Question.any_instance.stub(:run_validations!) { true }
      end

      it "downloads the question to another quiz" do
        expect do
          post :download, quiz_id: @quiz.id, id: @question.id, location: @quiz.id
        end.to change { @quiz.questions.count }.by 1
      end
    end

    describe "#destroy" do
      it "destroyes the question" do
        delete :destroy, quiz_id: @quiz.id, id: @question.id
        expect(Question.exists?(@question)).to be_false
      end
    end
  end
end
