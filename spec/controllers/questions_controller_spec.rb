require "spec_helper"

describe QuestionsController, user: :school do
  before do
    @school = FactoryGirl.create(:school)
    login_as(@school)
    @quiz = FactoryGirl.create(:quiz, school: @school)
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
        before { valid!(BooleanQuestion) }

        it "creates the question" do
          post :create, quiz_id: @quiz.id, category: "boolean", question: {content: "Foo"}
          expect(@quiz.questions.first).to be_a(BooleanQuestion)
        end
      end

      context "when invalid" do
        before { invalid!(BooleanQuestion) }

        it "doesn't raise errors" do
          post :create, quiz_id: @quiz.id, category: "boolean", question: {content: nil}
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
        @quiz.questions = FactoryGirl.create_list(:question, 3)
        @questions = @quiz.questions.to_a
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
        @quiz.questions.reload

        expect(@quiz.questions).to eq [@questions[0], @questions[2], @questions[1]]
        expect(@quiz.questions.pluck(:position)).to eq [1, 2, 3]
      end
    end
  end

  context "member" do
    before do
      @question = FactoryGirl.create(:question, quiz: @quiz)
    end

    describe "#edit" do
      it "doesn't raise errors" do
        get :edit, quiz_id: @quiz.id, id: @question.id
      end
    end

    describe "#update" do
      context "when valid" do
        before { valid!(@question.class) }

        it "updates the record" do
          put :update, quiz_id: @quiz.id, id: @question.id, category: @question.category, question: {content: "New content"}
          expect(@question.reload.content).to eq "New content"
        end
      end

      context "when not valid" do
        before { invalid!(@question.class) }

        it "doesn't raise errors" do
          put :update, quiz_id: @quiz.id, id: @question.id, category: @question.category, question: {content: nil}
        end
      end
    end

    describe "#download_location" do
      it "doesn't raise errors" do
        get :download_location, quiz_id: @quiz.id, id: @question.id
      end
    end

    describe "#download" do
      it "downloads the question to another quiz" do
        expect do
          post :download, quiz_id: @quiz.id, id: @question.id, location: @quiz.id
        end.to change{@quiz.questions.count}.by 1
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
