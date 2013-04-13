require "spec_helper"

describe GamesController do
  student!

  before do
    @school = Factory.create_without_validation(:empty_school)
    @student = Factory.create_without_validation(:empty_student, school: @school)
    @quiz = Factory.create_without_validation(:empty_quiz, school: @school)
    @quiz.questions = Array.new(3, Factory.create_without_validation(:empty_question))

    controller.send(:log_in!, @student)
  end

  let(:game_details) {
    {
      quiz_id:      @quiz.id,
      question_ids: @quiz.question_ids,
      player_ids:   [@student.id]
    }
  }

  describe "#new" do
    it "assigns quizzes" do
      get :new
      expect(assigns(:quizzes)).to eq [@quiz]
    end
  end

  describe "#create" do
    context "when valid" do
      before do
        GameDetails.any_instance.stub(:valid?) { true }
        GameDetails.any_instance.stub(:to_h) { game_details }
      end

      it "initializes the game" do
        controller.send(:game).should_receive(:initialize!)
        post :create
      end

      it "redirects to game" do
        post :create
        expect(response).to redirect_to edit_game_path
      end
    end

    context "when invalid" do
      it "assigns quizzes" do
        post :create
        expect(assigns(:quizzes)).to eq [@quiz]
      end
    end
  end

  describe "#edit" do
    before do
      controller.send(:game).initialize!(game_details)
    end

    it "doesn't raise errors" do
      get :edit
    end
  end

  describe "#update" do
    before do
      controller.send(:game).initialize!(game_details)
    end

    it "invokes #save_answer!" do
      controller.send(:game).should_receive(:save_answer!)
      put :update
    end

    it "redirects to feedback" do
      put :update
      expect(response).to redirect_to(feedback_game_path)
    end
  end

  describe "#feedback" do
    before do
      controller.send(:game).initialize!(game_details)
    end

    it "doesn't raise errors" do
      get :feedback
    end
  end

  describe "#next_question" do
    before do
      controller.send(:game).initialize!(game_details)
    end

    it "invokes #next_question!" do
      controller.send(:game).should_receive(:next_question!)
      get :next_question
    end

    it "redirects to game" do
      get :next_question
      expect(response).to redirect_to(edit_game_path)
    end
  end

  describe "#show" do
    before do
      controller.send(:game).initialize!(game_details)
      controller.send(:game).finalize!
    end

    it "doesn't raise errors" do
      get :show
    end
  end

  describe "#delete" do
    it "doesn't raise errors" do
      get :delete
    end
  end

  describe "#destroy" do
    before do
      controller.send(:game).initialize!(game_details)
    end

    it "creates the game" do
      expect {
        delete :destroy
      }.to change { PlayedGame.count }.by 1
    end
  end
end
