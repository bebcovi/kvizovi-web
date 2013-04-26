require "spec_helper"

describe QuizController, user: :student do
  before do
    @school    = Factory.create(:school)
    @student   = Factory.create(:student, school: @school)
    @quiz      = Factory.create(:quiz, :activated, school: @school)
    @questions = Factory.create_list(:question, 3, quiz: @quiz)

    login_as(@student)
  end

  let(:game_details) do
    {
      quiz_id:      @quiz.id,
      question_ids: @questions.map(&:id),
      player_ids:   [@student.id],
    }
  end

  describe "#new" do
    it "assigns quizzes" do
      get :new
      expect(assigns(:quizzes)).to eq [@quiz]
    end
  end

  describe "#prepare" do
    context "when valid" do
      before do
        GameDetails.any_instance.stub(:valid?) { true }
        GameDetails.any_instance.stub(:to_h) { game_details }
      end

      it "prepares the quiz" do
        controller.send(:game).should_receive(:initialize!)
        post :prepare
      end

      it "redirects to quiz" do
        post :prepare
        expect(response).to redirect_to play_quiz_path
      end
    end

    context "when invalid" do
      before do
        GameDetails.any_instance.stub(:valid?) { false }
      end

      it "assigns quizzes" do
        post :prepare
        expect(assigns(:quizzes)).to eq [@quiz]
      end
    end
  end

  context "in game" do
    before do
      controller.send(:game).initialize!(game_details)
    end

    describe "#play" do
      it "doesn't raise errors" do
        get :play
      end
    end

    describe "#save_answer" do
      it "invokes #save_answer!" do
        controller.send(:game).should_receive(:save_answer!)
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
        controller.send(:game).should_receive(:next_question!)
        get :next_question
      end

      it "redirects to quiz" do
        get :next_question
        expect(response).to redirect_to(play_quiz_path)
      end
    end

    describe "#results" do
      before do
        controller.send(:game).finalize!
      end

      it "doesn't raise errors" do
        get :results
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
        expect(PlayedGame.count).to eq 1
      end
    end
  end
end
