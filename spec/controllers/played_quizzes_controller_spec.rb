require "spec_helper"

describe PlayedQuizzesController, user: :school do
  before do
    @school = Factory.create(:school)
    login_as(@school)
  end

  describe "#index" do
    before do
      @quiz_snapshot = Factory.create(:quiz_snapshot)
      @played_quiz = Factory.create(:played_quiz, quiz_snapshot: @quiz_snapshot)
    end

    context "on quiz" do
      before do
        @quiz = Factory.create(:quiz)
        @quiz_snapshot.update_attributes(quiz_id: @quiz.id)
      end

      it "assigns played quizzes" do
        get :index, quiz_id: @quiz.id
        expect(assigns(:played_quizzes)).to eq [@played_quiz]
      end
    end

    context "on student" do
      before do
        @student = Factory.create(:student)
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
    before do
      @quiz_snapshot = Factory.create(:quiz_snapshot)
      @played_quiz = Factory.create(:played_quiz, quiz_snapshot: @quiz_snapshot)
    end

    context "on quiz" do
      before do
        @quiz = Factory.create(:quiz)
        @quiz_snapshot.update_attributes(quiz_id: @quiz.id)
      end

      it "assigns the order" do
        get :show, id: @played_quiz.id, quiz_id: @quiz.id
        expect(assigns(:order)).to eq 1
      end
    end

    context "on student" do
      before do
        @student = Factory.create(:student)
        @played_quiz.students << @student
      end

      it "assigns the order" do
        get :show, id: @played_quiz.id, student_id: @student.id
        expect(assigns(:order)).to eq 1
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
