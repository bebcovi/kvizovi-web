require "spec_helper"

describe QuizzesController, user: :school do
  before do
    @school = Factory.create(:school)
    login_as(@school)
  end

  context "collection" do
    describe "#index" do
      it "assigns school's quizzes" do
        school_quiz = Factory.create(:quiz, school: @school)
        other_quiz  = Factory.create(:quiz)
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
          post :create
          expect(@school.quizzes.count).to eq 1
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
      @quiz = Factory.create(:quiz, school: @school)
    end

    describe "#edit" do
      it "doesn't raise errors" do
        get :edit, id: @quiz.id
      end
    end

    describe "#update" do
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

    describe "#destroy" do
      it "destroyes the record" do
        delete :destroy, id: @quiz.id
        expect(Quiz.exists?(@quiz)).to be_false
      end
    end
  end
end
