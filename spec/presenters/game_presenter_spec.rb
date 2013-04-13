require "spec_helper"

describe GamePresenter do
  before do
    @players = 2.times.map { Factory.create_without_validation(:empty_student) }
    @it = GamePresenter.new(hash, Student)
  end

  let(:hash) do
    {
      questions: [
        {answer: true},
        {answer: true},
        {answer: false},
        {answer: true},
      ],
      players: [
        {id: @players.first.id},
        {id: @players.last.id},
      ],
    }
  end

  it "has players" do
    @it.players.should eq @players
  end

  it "has scores" do
    expect(@it.scores).to eq [1, 2]
  end

  it "has score percentages" do
    expect(@it.score_percentages).to eq [50, 100]
  end

  it "has player numbers" do
    expect(@it.player_numbers).to eq [1, 2]
  end

  it "has ranks" do
    expect(@it.ranks.all?(&:present?)).to be_true
  end

  it "has total score" do
    expect(@it.total_score).to eq 2
  end
end
