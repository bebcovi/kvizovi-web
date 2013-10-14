require "spec_helper"

describe PlayedQuizDecorator do
  before do
    @it = PlayedQuizDecorator.new(played_quiz)
  end

  let(:played_quiz) do
    double(
      questions:        FactoryGirl.build_list(:boolean_question, 4, answer: false),
      students:         FactoryGirl.build_list(:student, 2),
      question_answers: [false, false, true, false],
      has_answers?:     true,
    )
  end

  it "has results" do
    @it.results
  end

  it "has scores" do
    expect(@it.scores).to eq [1, 2]
  end

  it "has score percentages" do
    expect(@it.score_percentages).to eq [50, 100]
  end

  it "has student numbers" do
    expect(@it.student_numbers).to eq [1, 2]
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
