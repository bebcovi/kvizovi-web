require "spec_helper"

describe QuizzesController do
  let(:school)    { create(:school) }
  let(:quiz)      { create(:quiz, school: school, questions: questions) }
  let(:questions) { create_list(:question, 3) }

  before do
    login_as(:student)
    current_user.update(school: school)
  end

  def game
    controller.send(:game)
  end

  def start_quiz
    game.start!(quiz, [current_user])
  end

  def finish_quiz
    loop do
      game.save_answer!("foo")
      break if game.current_question == game.questions.last
      game.next_question!
    end
    game.finish!
  end

  describe "#index" do
    it "renders the template" do
      get :index
      expect(response).to be_a_success
    end
  end

  describe "#show" do
    it "renders the template" do
      get :show, id: quiz.id
      expect(response).to be_a_success
    end

    it "redirects with an error message on inactive quiz" do
      quiz.update(activated: false)
      get :show, id: quiz.id

      expect(response).to be_a_redirect
      expect(flash[:alert]).to be_present
    end

    it "redirects with an error message on missing quiz" do
      get :show, id: "foo"

      expect(response).to be_a_redirect
      expect(flash[:alert]).to be_present
    end
  end

  describe "#start" do
    before do
      allow(game).to receive(:start!).and_call_original
      post :start, id: quiz.id
    end

    it "starts the quiz" do
      expect(game).to have_received(:start!)
    end

    it "redirects to quiz" do
      expect(response).to redirect_to play_quiz_path(quiz)
    end
  end

  describe "#play" do
    before { start_quiz }

    before do
      get :play, id: quiz.id
    end

    it "renders the template" do
      expect(response).to be_a_success
    end
  end

  describe "#save_answer" do
    before { start_quiz }

    before do
      allow(game).to receive(:save_answer!)
      put :save_answer, id: quiz.id, format: :js
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
      get :next_question, id: quiz.id
    end

    it "invokes #next_question!" do
      expect(game).to have_received(:next_question!)
    end

    it "redirects to quiz" do
      expect(response).to redirect_to(play_quiz_path(quiz))
    end
  end

  describe "#results" do
    before { start_quiz }
    before { finish_quiz }

    before do
      get :results, id: quiz.id
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
        delete :finish, id: quiz.id
      end

      it "redirects to results" do
        expect(response).to redirect_to(results_quiz_path(quiz))
      end
    end

    context "when the quiz was interrupted" do
      before do
        allow(game).to receive(:interrupted?).and_return(true)
        delete :finish, id: quiz.id
      end

      it "redirects to beginning" do
        expect(response).to redirect_to(quizzes_path)
      end
    end
  end
end
