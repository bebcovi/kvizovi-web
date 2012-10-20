require "spec_helper_full"

describe GameReview do
  before(:all) do
    @school = create(:school)
    @players = [create(:janko, school: @school), create(:matija, school: @school)]
    @quiz = create(:quiz, school: @school)
    @questions = create_list(:choice_question, 4, quiz: @quiz)
  end

  let(:info) do
    {
      player_ids: @players.map(&:id),
      quiz_id: @quiz.id,
      question_ids: @questions.map(&:id),
      question_answers: [true, true, true, false],
      player_class: Student
    }
  end

  before(:each) { @it = GameReview.new(info) }
  subject { @it }

  it "knows players" do
    @it.players.should eq @players
  end

  it "knows scores" do
    @it.scores.should eq [@questions.first.points + @questions.third.points, @questions.second.points]
  end

  it "knows total score" do
    @it.total_score.should eq @questions.map(&:points).inject(:+) / @players.count
  end

  it "knows player numbers" do
    @it.player_numbers.should eq [1, 2]
  end

  it "knows ranks" do
    @it.ranks.should eq ["super-ekspert", "ekspert"]
  end

  it "knows questions count" do
    @it.questions_count.should eq @questions.count
  end

  it "fetches results" do
    expect { @it.results }.to_not raise_error
  end

  after(:all) { @school.destroy }
end
