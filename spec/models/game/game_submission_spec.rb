require "spec_helper_lite"
require_relative "../../../app/models/game/game_submission"

describe GameSubmission do
  before(:each) { @it = build(:game_submission) }
  subject { @it }

  before(:each) do
    stub_const("Quiz", Class.new)
    stub_const("Player", Class.new)
  end

  describe "#info" do
    it "fetches the info correctly" do
      @it.stub(:quiz_id) { 1 }
      @it.stub(:quiz) { double("quiz", question_ids: [1, 2, 3, 4]) }
      @it.stub(:players) { [double("player", id: 1), double("player", id: 2)] }

      @it.info[:quiz_id].should eq 1
      (1..4).each { |id| @it.info[:question_ids].should include(id) }
      (1..2).each { |id| @it.info[:player_ids].should include(id) }
    end
  end

  describe "validations" do
    it "validates presence of #quiz_id" do
      @it.quiz_id = nil
      @it.should_not be_valid
    end

    it "validates presence of #players_count" do
      @it.players_count = nil
      @it.should_not be_valid
    end

    describe "validation of authenticity of players" do
      it "matches the number of authenticated players with #players_count" do
        @it.players_count = 1
        @it.players_credentials = []
        @it.should_not be_valid

        @it.players_credentials = [{}]
        Player.stub(:authenticate) { true }
        @it.should be_valid
      end

      it "rejects both nil and false" do
        @it.players_count = 1
        @it.players_credentials = [{}]

        Player.stub(:authenticate) { false }
        @it.should_not be_valid
        Player.stub(:authenticate) { nil }
        @it.should_not be_valid
      end

      it "clears out duplicate players" do
        @it.players_count = 2
        @it.players_credentials = [{}, {}]
        Player.stub(:authenticate) { "student" }
        @it.should_not be_valid
      end

      it "doesn't give validation errors when #players_count is blank" do
        @it.players_count = nil
        @it.valid?
        @it.errors[:players_credentials].should be_empty

        @it.players_count = ""
        @it.valid?
        @it.errors[:players_credentials].should be_empty
      end
    end
  end
end
