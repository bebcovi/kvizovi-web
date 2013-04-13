require "spec_helper"

describe GameDetails do
  before do
    @it = GameDetails.new
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

        @it.player_class = Student
        Factory.create_without_validation(:empty_student, username: "janko", password: "secret")
        Factory.create_without_validation(:empty_student, username: "matija", password: "secret")
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
      @quiz    = Factory.create_without_validation(:empty_quiz)
      @players = Array.new(2, Factory.create_without_validation(:empty_student))

      @it.quiz_id = @quiz.id
      @it.players = @players
    end

    it "adjusts the number of questions according to the number of players" do
      questions = 4.times.map { Factory.create_without_validation(:empty_question) }

      @quiz.questions = questions.first(4)
      expect(@it.to_h[:question_ids].count).to eq 4

      @quiz.questions = questions.first(3)
      expect(@it.to_h[:question_ids].count).to eq 2
    end
  end
end
