require "spec_helper_full"

describe QuestionsController do
  describe "actions" do
    before(:all) do
      @quiz = create(:quiz)
      @question = create(:question, quiz: @quiz)
      create(:question)
    end

    before(:each) do
      controller.stub(:assign_quiz) { controller.instance_variable_set("@quiz", @quiz) }
    end

    describe "#index" do
      let(:action) { ->{ get :index, quiz_id: @quiz.id } }
      before(:each) { action.call }

      it "@questions and renders :index" do
        assigns(:questions).first.should eq @question
        response.should render_template(:index)
      end
    end

    describe "#new" do
      context "category not present" do
        let(:action) { ->{ get :new, quiz_id: @quiz.id } }
        before(:each) { action.call }

        it "renders :new" do
          response.should render_template(:new)
        end
      end

      context "category present" do
        let(:action) { ->{ get :new, quiz_id: @quiz.id, category: "boolean" } }
        before(:each) { action.call }

        it "@question and renders :new" do
          assigns(:question).should be_a_new(BooleanQuestion)
          response.should render_template(:new)
        end
      end
    end

    describe "#create" do
      context "valid record" do
        let(:action) { ->{ post :create, quiz_id: @quiz.id, question: attributes_for(:question) } }

        it "creates the record and redirects back to questions" do
          expect { action.call }.to change{Question.count}.by(1)
          response.should redirect_to(quiz_questions_path(@quiz))
          flash[:notice].should_not be_nil
        end

        after(:all) { Question.last.destroy }
      end

      context "invalid record" do
        let(:action) { ->{ post :create, quiz_id: @quiz.id, question: {} } }

        it "doesn't create the record, assigns @question and renders :new" do
          expect { action.call }.to_not change{Question.count}
          assigns(:question).should be_a_new(Question)
          response.should render_template(:new)
        end
      end
    end

    describe "#edit" do
      let(:action) { ->{ get :edit, quiz_id: @quiz.id, id: @question.id } }
      before(:each) { action.call }

      it "assigns @question renders :edit" do
        assigns(:question).should eq @question
        response.should render_template(:edit)
      end
    end

    describe "#update" do
      context "valid record" do
        let(:action) { ->{ put :update, quiz_id: @quiz.id, id: @question.id, question: {content: "Changed"} } }

        it "updates the record and redirects back to questions" do
          expect { action.call }.to change{@question.reload.content}.to("Changed")
          response.should redirect_to(quiz_questions_path(@quiz))
          flash[:notice].should_not be_nil
        end
      end

      context "invalid record" do
        let(:action) { ->{ put :update, quiz_id: @quiz.id, id: @question.id, question: {content: ""} } }

        it "doesn't update the record, assigns @question and renders :edit" do
          expect { action.call }.to_not change{@question.reload.content}.to("")
          assigns(:question).should eq @question
          response.should render_template(:edit)
        end
      end
    end

    describe "#destroy" do
      let(:action) { ->(question){ delete :destroy, quiz_id: @quiz.id, id: question.id } }

      it "deletes the record and redirects back to questions" do
        question = create(:question, quiz: @quiz)
        expect { action.call(question) }.to change{Question.count}.by(-1)
        response.should redirect_to(quiz_questions_path(@quiz))
        flash[:notice].should_not be_nil
      end

      it "goes through quiz" do
        question = create(:question, quiz_id: @quiz.id + 1)
        expect { action.call(question) }.to_not change{Question.count}.by(-1)
      end
    end

    after(:all) { @quiz.destroy }
  end

  describe "methods" do
    describe "#assign_quiz" do
      before(:all) do
        @school = create(:school)
        @quiz = create(:quiz, school: @school)
      end

      before(:each) do
        controller.stub(:current_school) { @school }
      end

      it "assigns the quiz" do
        controller.stub(:params) { {quiz_id: @quiz.id} }
        controller.send(:assign_quiz)
        controller.instance_variable_get("@quiz").should eq @quiz
      end

      it "goes through the current school" do
        quiz = create(:quiz, school_id: @school.id + 1)
        controller.stub(:params) { {quiz_id: quiz.id} }
        expect { controller.send(:assign_quiz) }.to raise_error(ActiveRecord::RecordNotFound)

        quiz.destroy
      end

      after(:all) { @school.destroy }
    end
  end
end
