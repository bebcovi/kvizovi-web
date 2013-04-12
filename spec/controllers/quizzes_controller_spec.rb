require "spec_helper"

describe QuizzesController do
  school!

  before do
    @user = Factory.create_without_validation(:empty_school)
    controller.send(:log_in!, @user)
  end

  context "collection" do
    describe "#index" do
      it "assigns school's quizzes" do
        school_quiz = Factory.create_without_validation(:empty_quiz, school: @user)
        other_quiz  = Factory.create_without_validation(:empty_quiz)
        get :index
        expect(assigns(:quizzes)).to eq [school_quiz]
      end
    end

    describe "#new" do
      it "doesn't raise errors" do
        get :new
      end
    end

    describe "#create" do
      context "when valid" do
        before do
          Quiz.any_instance.stub(:valid?) { true }
        end

        it "creates the record" do
          expect {
            post :create
          }.to change { @user.quizzes.count }.by 1
        end
      end

      context "when invalid" do
        before do
          Quiz.any_instance.stub(:valid?) { false }
        end

        it "doesn't raise errors" do
          post :create
        end
      end
    end
  end

  context "member" do
    before do
      @quiz = Factory.create_without_validation(:empty_quiz, school: @user)
    end

    describe "#edit" do
      it "doesn't raise errors" do
        get :edit, id: @quiz.id
      end
    end

    describe "#update" do
      it "scopes to current user" do
        other_quiz = Factory.create_without_validation(:empty_quiz)
        expect {
          put :update, id: other_quiz.id
        }.to raise_error(ActiveRecord::RecordNotFound)
      end

      context "when valid" do
        before do
          Quiz.any_instance.stub(:valid?) { true }
        end

        it "updates the record" do
          put :update, id: @quiz.id, quiz: {name: "New name"}
          expect(@quiz.reload.name).to eq "New name"
        end
      end

      context "when invalid" do
        before do
          Quiz.any_instance.stub(:valid?) { false }
        end

        it "doesn't raise erorrs" do
          put :update, id: @quiz.id
        end
      end
    end

    describe "#toggle_activation" do
      it "toggles quiz's activation" do
        expect { put :toggle_activation, id: @quiz.id }.to change { @quiz.reload.activated? }
        expect { put :toggle_activation, id: @quiz.id }.to change { @quiz.reload.activated? }
      end
    end

    describe "#destroy" do
      it "scopes to current user" do
        other_quiz = Factory.create_without_validation(:empty_quiz)
        expect { delete :destroy, id: other_quiz.id }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "destroyes the record" do
        delete :destroy, id: @quiz.id
        expect(Quiz.exists?(@quiz)).to be_false
      end
    end
  end
end
