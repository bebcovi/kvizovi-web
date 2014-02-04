require "spec_helper"

describe Game do
  subject { described_class.new({}) }

  let(:quiz)      { create(:quiz, questions: questions) }
  let(:questions) { create_list(:boolean_question, 2) }
  let(:players)   { create_list(:student, 2) }

  before do
    subject.start!(quiz, players)
  end

  describe "#start!" do
    it "starts the game" do
      expect(subject.current_question).to eq subject.questions.first
      expect(subject.current_player).to eq subject.players.first
    end
  end

  describe "#save_answer!" do
    it "saves the answer" do
      subject.save_answer!("foo")
      expect(subject.current_question_answer).to eq "foo"
    end

    it "doesn't save the answer if the current question was already answered" do
      subject.save_answer!("foo")
      subject.save_answer!("bar")
      expect(subject.current_question_answer).to eq "foo"
    end
  end

  describe "#next_question!" do
    it "advances to the next question" do
      subject.save_answer!("foo")
      expect { subject.next_question! }.to change{subject.current_question_number}.by 1
    end

    it "advances to the next player" do
      subject.save_answer!("foo")
      expect { subject.next_question! }.to change{subject.current_player_number}.by 1
    end

    it "doesn't advance to the next question if the current one wasn't answered" do
      expect { subject.next_question! }.not_to change{subject.current_question_number}
    end
  end

  describe "#finish!" do
    it "marks quiz as interrupted if it wasn't finished" do
      subject.finish!
      expect(subject.send(:played_quiz)).to be_interrupted
    end
  end
end
