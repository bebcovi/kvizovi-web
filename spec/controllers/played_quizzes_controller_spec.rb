require "spec_helper"

describe PlayedQuizzesController do
  let(:quiz_snapshot) { create(:quiz_snapshot, quiz_id: quiz.id) }
  let(:quiz)          { create(:quiz, school: current_user) }
  let(:student)       { create(:student, school: current_user) }

  before { login_as(:school) }

  before do
    @played_quiz = create(:played_quiz, quiz_snapshot: quiz_snapshot)
    create(:playing, played_quiz: @played_quiz, player: student)
  end

  describe "#index" do
    context "on quiz" do
      before do
        get :index, quiz_id: quiz.id
      end

      it "assigns played quizzes" do
        expect(assigns(:played_quizzes)).to eq [@played_quiz]
      end
    end

    context "on student" do
      before do
        get :index, student_id: student.id
      end

      it "assigns played quizzes" do
        expect(assigns(:played_quizzes)).to eq [@played_quiz]
      end
    end

    context "on nothing" do
      before do
        get :index
      end

      it "assigns played quizzes" do
        expect(assigns(:played_quizzes)).to eq [@played_quiz]
      end
    end
  end

  describe "#show" do
    context "on quiz" do
      before do
        get :show, id: @played_quiz.id, quiz_id: quiz.id
      end

      it "assigns the position" do
        expect(assigns(:position)).to eq 1
      end
    end

    context "on student" do
      before do
        get :show, id: @played_quiz.id, student_id: student.id
      end

      it "assigns the position" do
        expect(assigns(:position)).to eq 1
      end
    end

    context "on nothing" do
      before do
        get :show, id: @played_quiz.id
      end

      it "assigns the played quiz" do
        expect(assigns(:played_quiz)).to eq @played_quiz
      end
    end
  end
end
