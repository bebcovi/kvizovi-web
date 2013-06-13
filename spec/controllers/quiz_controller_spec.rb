require "spec_helper"

describe QuizController, user: :student do
  before do
    @school    = FactoryGirl.create(:school)
    @student   = FactoryGirl.create(:student, school: @school)
    @quiz      = FactoryGirl.create(:quiz, activated: true, school: @school)
    @questions = FactoryGirl.create_list(:question, 3, quiz: @quiz)

    login_as(@student)
  end

  describe "#choose" do
    it "assigns quizzes" do
      get :choose
      expect(assigns(:quizzes)).to eq [@quiz]
    end
  end

  describe "#start" do
    context "when valid" do
      it "prepares the quiz" do
        QuizPlay.any_instance.should_receive(:start!)
        post :start, quiz_specification: {quiz_id: @quiz.id, students_count: 1}
      end

      it "redirects to quiz" do
        post :start, quiz_specification: {quiz_id: @quiz.id, students_count: 1}
        expect(response).to redirect_to play_quiz_path
      end
    end

    context "when invalid" do
      before { invalid!(QuizSpecification) }

      it "assigns quizzes" do
        post :start, quiz_specification: {quiz_id: nil}
        expect(assigns(:quizzes)).to eq [@quiz]
      end
    end
  end

  context "in game" do
    before do
      QuizPlay.new(cookies).start!(quiz_snapshot, [@student])
    end

    let(:quiz_snapshot) do
      QuizSnapshot.capture(stub(quiz: @quiz, students: [@student]))
    end

    describe "#play" do
      it "doesn't raise errors" do
        get :play
      end

      it "redirects if the current question was already answered" do
        QuizPlay.new(cookies).save_answer!(true)
        get :play
        expect(response).to redirect_to(next_question_quiz_path)
      end
    end

    describe "#save_answer" do
      it "invokes #save_answer!" do
        QuizPlay.any_instance.should_receive(:save_answer!)
        put :save_answer
      end

      it "redirects to feedback" do
        put :save_answer
        expect(response).to redirect_to(answer_feedback_quiz_path)
      end
    end

    describe "#answer_feedback" do
      it "doesn't raise errors" do
        get :answer_feedback
      end
    end

    describe "#next_question" do
      it "invokes #next_question!" do
        QuizPlay.any_instance.should_receive(:next_question!)
        get :next_question
      end

      it "redirects to quiz" do
        get :next_question
        expect(response).to redirect_to(play_quiz_path)
      end
    end

    describe "#results" do
      before do
        QuizPlay.new(cookies).finish!
        @played_quiz = FactoryGirl.create(:played_quiz, quiz_snapshot: quiz_snapshot)
      end

      it "doesn't raise errors" do
        get :results, id: @played_quiz.id
      end
    end

    describe "#interrupt" do
      it "doesn't raise errors" do
        get :interrupt
      end
    end

    describe "#finish" do
      it "creates the game" do
        delete :finish
        expect(PlayedQuiz.count).to eq 1
      end

      context "quiz is not interrupted" do
        before { QuizPlay.any_instance.stub(:interrupted?) { false } }

        it "redirects to results" do
          delete :finish
          expect(response).to redirect_to(results_quiz_path(id: PlayedQuiz.first.id))
        end
      end

      context "quiz is interrupted" do
        before { QuizPlay.any_instance.stub(:interrupted?) { true } }

        it "redirects to beginning" do
          delete :finish
          expect(response).to redirect_to(choose_quiz_path)
        end
      end
    end
  end
end
