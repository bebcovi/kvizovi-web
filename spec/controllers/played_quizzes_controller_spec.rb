require "spec_helper"

describe PlayedQuizzesController, user: :school do
  before do
    @school = FactoryGirl.create(:school)
    login_as(@school)
  end

  before do
    @quiz = FactoryGirl.create(:quiz, school: @school)
    @quiz_snapshot = FactoryGirl.create(:quiz_snapshot, quiz_id: @quiz.id)
    @played_quiz = FactoryGirl.create(:played_quiz, quiz_snapshot: @quiz_snapshot)
  end

  describe "#index" do
    context "on quiz" do
      before do
        @quiz = FactoryGirl.create(:quiz)
        @quiz_snapshot.update_attributes(quiz_id: @quiz.id)
      end

      it "assigns played quizzes" do
        get :index, quiz_id: @quiz.id
        expect(assigns(:played_quizzes)).to eq [@played_quiz]
      end
    end

    context "on student" do
      before do
        @student = FactoryGirl.create(:student)
        @played_quiz.students << @student
      end

      it "assigns played quizzes" do
        get :index, student_id: @student.id
        expect(assigns(:played_quizzes)).to eq [@played_quiz]
      end
    end

    context "on nothing" do
      it "assigns played quizzes" do
        get :index
        expect(assigns(:played_quizzes)).to eq [@played_quiz]
      end
    end
  end

  describe "#show" do
    context "on quiz" do
      before do
        @quiz = FactoryGirl.create(:quiz)
        @quiz_snapshot.update_attributes(quiz_id: @quiz.id)
      end

      it "assigns the order" do
        get :show, id: @played_quiz.id, quiz_id: @quiz.id
        expect(assigns(:order)).to eq 1
      end
    end

    context "on student" do
      before do
        @student = FactoryGirl.create(:student)
        @played_quiz.students << @student
      end

      it "assigns the order" do
        get :show, id: @played_quiz.id, student_id: @student.id
        expect(assigns(:order)).to eq 1
      end
    end

    context "on missing played quiz" do
      it "redirects back with an error message" do
        get :show, id: @played_quiz.id + 1
        expect(response).to redirect_to(played_quizzes_path)
        expect(flash[:alert]).to be_present
      end
    end

    context "on nothing" do
      it "assigns the played quiz" do
        get :show, id: @played_quiz.id
        expect(assigns(:played_quiz)).to eq @played_quiz
      end
    end
  end
end
