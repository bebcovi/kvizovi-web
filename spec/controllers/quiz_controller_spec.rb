require "spec_helper"

describe QuizController do
  before do
    login_as(:student)

    @school    = create(:school)
    @student   = current_user
    @quiz      = create(:quiz, school: @school)
    @questions = create_list(:question, 3, quiz: @quiz)

    @student.update(school: @school)
  end

  let(:quiz_snapshot) do
    QuizSnapshot.capture(double(quiz: @quiz, students: [@student]))
  end

  def start_quiz
    controller.send(:quiz_play).start!(quiz_snapshot, [@student])
  end

  def finish_quiz
    controller.send(:quiz_play).finish!
  end

  describe "#choose" do
    before do
      get :choose
    end

    it "assigns quizzes" do
      expect(assigns(:quizzes)).to eq [@quiz]
    end
  end

  describe "#start" do
    before do
      allow(controller.send(:quiz_play)).to receive(:start!)
    end

    context "when valid" do
      before do
        post :start, quiz_specification: {quiz_id: @quiz.id, students_count: 1}
      end

      it "prepares the quiz" do
        expect(controller.send(:quiz_play)).to have_received(:start!)
      end

      it "redirects to quiz" do
        expect(response).to redirect_to play_quiz_path
      end
    end

    context "when invalid" do
      before do
        post :start, quiz_specification: {quiz_id: nil}
      end

      it "assigns quizzes" do
        expect(assigns(:quizzes)).to eq [@quiz]
      end
    end
  end

  describe "#play" do
    before { start_quiz }

    context "when the current question isn't answered" do
      before do
        get :play
      end

      it "renders the template" do
        expect(response).to be_a_success
      end
    end

    context "when the current question is already answered" do
      before do
        controller.send(:quiz_play).save_answer!(true)
        get :play
      end

      it "redirects to the next question" do
        expect(response).to redirect_to(next_question_quiz_path)
      end
    end
  end

  describe "#save_answer" do
    before { start_quiz }

    before do
      allow(controller.send(:quiz_play)).to receive(:save_answer!)
      put :save_answer, format: :js
    end

    it "invokes #save_answer!" do
      expect(controller.send(:quiz_play)).to have_received(:save_answer!)
    end

    it "renders the template" do
      expect(response).to be_a_success
    end
  end

  describe "#next_question" do
    before { start_quiz }

    before do
      allow(controller.send(:quiz_play)).to receive(:next_question!)
      get :next_question
    end

    it "invokes #next_question!" do
      expect(controller.send(:quiz_play)).to have_received(:next_question!)
    end

    it "redirects to quiz" do
      expect(response).to redirect_to(play_quiz_path)
    end
  end

  describe "#results" do
    before { start_quiz }
    before { finish_quiz }

    before do
      @played_quiz = create(:played_quiz, quiz_snapshot: quiz_snapshot)
      get :results, id: @played_quiz.id
    end

    it "renders the template" do
      expect(response).to be_a_success
    end
  end

  describe "#finish" do
    before { start_quiz }

    context "when the quiz was played to the end" do
      before do
        allow(controller.send(:quiz_play)).to receive(:interrupted?).and_return(false)
        delete :finish
      end

      it "redirects to results" do
        expect(response).to redirect_to(results_quiz_path(id: PlayedQuiz.last.id))
      end
    end

    context "when the quiz was interrupted" do
      before do
        allow(controller.send(:quiz_play)).to receive(:interrupted?).and_return(true)
        delete :finish
      end

      it "redirects to beginning" do
        expect(response).to redirect_to(choose_quiz_path)
      end
    end

    it "creates the game" do
      delete :finish
      expect(PlayedQuiz.count).to eq 1
    end
  end
end
