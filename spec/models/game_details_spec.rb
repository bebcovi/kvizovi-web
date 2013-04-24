require "spec_helper"

describe GameDetails do
  before do
    @it = GameDetails.new
    @it.player_class = Student
  end

  context "validations" do
    context "#quiz_id" do
      it "validates presence" do
        @it.quiz_id = nil
        expect(@it).to have(1).error_on(:quiz_id)
      end
    end

    context "#players_count" do
      it "validates presence" do
        @it.players_count = nil
        expect(@it).to have(1).error_on(:players_count)
      end
    end

    context "#players_credentials" do
      it "validates authenticity" do
        @it.players_count = 2

        expect(@it).to have(1).error_on(:players_credentials)

        Factory.create(:student, username: "janko", password: "secret")
        Factory.create(:student, username: "matija", password: "secret")
        @it.players_credentials = [
          {username: "janko",  password: "secret"},
          {username: "matija", password: "secret"},
        ]

        expect(@it).to have(0).errors_on(:players_credentials)
      end
    end
  end

  describe "#to_h" do
    before do
      @quiz    = Factory.create(:quiz)
      @players = Factory.create_list(:student, 2)

      @it.quiz_id = @quiz.id
      @it.players = @players
    end

    it "adjusts the number of questions according to the number of players" do
      @quiz.questions = Factory.create_list(:question, 4)
      expect(@it.to_h[:question_ids].count).to eq 4

      @quiz.questions = Factory.create_list(:question, 3)
      expect(@it.to_h[:question_ids].count).to eq 2
    end
  end
end
