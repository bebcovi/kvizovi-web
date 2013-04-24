require "spec_helper"

describe GamePresenter do
  before do
    @players = Factory.create_list(:student, 2)
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

  it "has results" do
    @it.results
  end

  it "has players" do
    expect(@it.players).to eq @players
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
    @it.ranks.each do |rank|
      expect(rank).to be_present
    end
  end

  it "has total score" do
    expect(@it.total_score).to eq 2
  end
end
