require "spec_helper_full"
require "set"

describe GameSubmission do
  before(:all) do
    @quiz = create(:quiz)
    @questions = []
    @questions += create_list(:boolean_question, 2, quiz: @quiz)
    @questions += create_list(:choice_question, 2, quiz: @quiz)
    @questions += create_list(:association_question, 2, quiz: @quiz)
    @players = [create(:janko), create(:matija)]
  end

  before(:each) { @it = build(:game_submission, player_class: Student) }
  subject { @it }

  describe "#info" do
    before(:each) do
      @it.quiz_id = @quiz.id
      @it.players_count = @players.count
      @it.players = @players
    end

    it "is correct" do
      @it.info[:quiz_id].should eq @quiz.id
      Set.new(@it.info[:question_ids]).should eq Set.new(@questions.map(&:id))
      Set.new(@it.info[:player_ids]).should eq Set.new(@players.map(&:id))
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

        @it.players_credentials = [attributes_for(:janko)]
        @it.should be_valid
      end

      it "succesfully authenticates players" do
        @it.players_count = 1

        @it.players_credentials = [{username: "johndoe", password: "secret"}]
        @it.should_not be_valid

        @it.players_credentials = [{username: "janko", password: "wrong"}]
        @it.should_not be_valid
      end
    end

    it "validates uniqueness of players" do
      @it.players_count = 2
      @it.players_credentials = [attributes_for(:janko), attributes_for(:janko)]
      @it.should_not be_valid
    end

    it "doesn't give validation errors on #players_credentials when #players_count is blank" do
      @it.players_count = nil
      @it.valid?
      @it.errors[:players_credentials].should be_empty

      @it.players_count = ""
      @it.valid?
      @it.errors[:players_credentials].should be_empty
    end
  end

  after(:all) do
    @quiz.destroy
    @players.each(&:destroy)
  end
end
