require "spec_helper"

describe PlayedQuizDecorator do
  subject { described_class.new(played_quiz) }

  let(:played_quiz) do
    double(
      questions: questions,
      players: players,
      question_answers: answers,
      has_answers?: true,
    )
  end
  let(:players)   { create_list(:student, 2) }
  let(:questions) { create_list(:boolean_question, 4, answer: false) }
  let(:answers)   { [false, true, false, nil] }

  before do
    allow(subject).to receive(:h).and_return(double.as_null_object)
  end

  describe "#results" do
    it "returns players" do
      expect(subject.results.map(&:first)).to eq players
    end

    it "returns scores" do
      expect(subject.results.map(&:second)).to eq subject.scores
    end
  end

  describe "#scores" do
    it "returns players' scores" do
      expect(subject.scores).to eq [2, 0]
    end

    it "returns proper scores when played quiz doesn't have answers" do
      allow(played_quiz).to receive(:has_answers?).and_return(false)
      expect(subject.scores).to eq [0, 1]
    end
  end

  describe "#total_score" do
    it "returns the total score" do
      expect(subject.total_score).to eq 2
      allow(played_quiz).to receive(:has_answers?).and_return(false)
      expect(subject.total_score).to eq 2
    end
  end

  describe "#played_questions" do
    it "returns questions" do
      expect(subject.played_questions.map(&:first)).to eq subject.questions
    end

    it "returns answers" do
      expect(subject.played_questions.map(&:second)).to eq answers
    end

    it "returns players" do
      expect(subject.played_questions.map(&:third)).to eq [players.first, players.second, players.first, players.second]
    end

    it "returns status" do
      expect(subject.played_questions.map(&:fourth)).to eq ["correct", "wrong", "correct", "unanswered"]
    end

    it "returns empty array when played quiz doesn't have answers" do
      allow(played_quiz).to receive(:has_answers?).and_return(false)
      allow(played_quiz).to receive(:questions).and_return(nil)
      expect(subject.played_questions).to eq []
    end
  end
end
