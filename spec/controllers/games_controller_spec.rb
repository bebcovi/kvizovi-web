require "spec_helper"

describe GamesController, user: :student do
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
      before do
        GameDetails.any_instance.stub(:valid?) { false }
      end

      it "assigns quizzes" do
        post :create
        expect(assigns(:quizzes)).to eq [@quiz]
      end
    end
  end

  context "in game" do
    before do
      controller.send(:game).initialize!(game_details)
    end

    describe "#edit" do
      it "doesn't raise errors" do
        get :edit
      end
    end

    describe "#update" do
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
      it "doesn't raise errors" do
        get :feedback
      end
    end

    describe "#next_question" do
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
      it "creates the game" do
        delete :destroy
        expect(PlayedGame.count).to eq 1
      end
    end
  end
end
