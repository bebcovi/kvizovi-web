require "spec_helper"

describe Game::State do
  subject { described_class.new({}) }

  let(:questions) { double(count: 2) }
  let(:players)   { double(count: 2) }

  before do
    subject.start_game!(questions, players)
  end

  describe "#next_question!" do
    it "changes the question" do
      expect { subject.next_question! }.to change{subject.current_question}.by 1
    end

    it "doesn't change the question if it is on the last question" do
      subject.next_question! until subject.current_question == questions.count - 1
      expect { subject.next_question! }.not_to change{subject.current_question}
      expect { subject.next_question! }.not_to change{subject.current_player}
    end
  end

  describe "#next_player!" do
    it "changes the player" do
      expect {
        subject.next_player!
      }.to change{subject.current_player}.by 1
    end
  end
end
