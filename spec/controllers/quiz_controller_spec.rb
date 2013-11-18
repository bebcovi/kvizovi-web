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

  def game
    controller.send(:game)
  end

  def start_quiz
    game.start!(@quiz, [@student])
  end

  def finish_quiz
    loop do
      game.save_answer!("foo")
      break if game.current_question == game.questions.last
      game.next_question!
    end
    game.finish!
  end

  describe "#choose" do
    before do
      get :choose
    end

    it "renders the template" do
      expect(response).to be_a_success
    end
  end

  describe "#start" do
    before do
      allow(game).to receive(:start!)
    end

    context "when valid" do
      before do
        post :start, game_specification: {quiz_id: @quiz.id, players_count: 1}
      end

      it "prepares the quiz" do
        expect(game).to have_received(:start!)
      end

      it "redirects to quiz" do
        expect(response).to redirect_to play_quiz_path
      end
    end

    context "when invalid" do
      before do
        post :start, game_specification: {quiz_id: nil}
      end

      it "renders the template" do
        expect(response).to be_a_success
      end
    end
  end

  describe "#play" do
    before { start_quiz }

    before do
      get :play
    end

    it "renders the template" do
      expect(response).to be_a_success
    end
  end

  describe "#save_answer" do
    before { start_quiz }

    before do
      allow(game).to receive(:save_answer!)
      put :save_answer, format: :js
    end

    it "invokes #save_answer!" do
      expect(game).to have_received(:save_answer!)
    end

    it "renders the template" do
      expect(response).to be_a_success
    end
  end

  describe "#next_question" do
    before { start_quiz }

    before do
      allow(game).to receive(:next_question!)
      get :next_question
    end

    it "invokes #next_question!" do
      expect(game).to have_received(:next_question!)
    end

    it "redirects to quiz" do
      expect(response).to redirect_to(play_quiz_path)
    end
  end

  describe "#results" do
    before { start_quiz }
    before { finish_quiz }

    before do
      get :results
    end

    it "renders the template" do
      expect(response).to be_a_success
    end
  end

  describe "#finish" do
    before { start_quiz }

    context "when the quiz was played to the end" do
      before do
        allow(game).to receive(:interrupted?).and_return(false)
        delete :finish
      end

      it "redirects to results" do
        expect(response).to redirect_to(results_quiz_path)
      end
    end

    context "when the quiz was interrupted" do
      before do
        allow(game).to receive(:interrupted?).and_return(true)
        delete :finish
      end

      it "redirects to beginning" do
        expect(response).to redirect_to(choose_quiz_path)
      end
    end
  end
end
