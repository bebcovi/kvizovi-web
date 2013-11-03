require "spec_helper"

describe PlayedQuizDecorator do
  subject { described_class.new(played_quiz) }

  let(:played_quiz) do
    double(
      questions:        build_list(:boolean_question, 4, answer: false),
      students:         build_list(:student, 2),
      question_answers: [false, false, true, false],
      has_answers?:     true,
    )
  end

  it "has results" do
    subject.results
  end

  it "has scores" do
    expect(subject.scores).to eq [1, 2]
  end

  it "has score percentages" do
    expect(subject.score_percentages).to eq [50, 100]
  end

  it "has student numbers" do
    expect(subject.student_numbers).to eq [1, 2]
  end

  it "has ranks" do
    subject.ranks.each do |rank|
      expect(rank).to be_present
    end
  end

  it "has total score" do
    expect(subject.total_score).to eq 2
  end
end
