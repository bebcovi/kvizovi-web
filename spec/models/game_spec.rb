require "spec_helper"

describe Game do
  before do
    @it = Game.new({})
    @it.initialize!(hash)
  end

  let(:hash) {
    {
      quiz_id:      2,
      question_ids: (2..10).to_a,
      player_ids:   (2..4).to_a,
    }
  }

  context "commands" do
    describe "#initialize!" do
      it "stores the begin time" do
        expect(@it.begin_time).to be_present
      end
    end

    describe "#save_answer!" do
      it "saves the answer" do
        answers = @it.questions_count.times.map { [true, false].sample }
        answers.each do |answer|
          @it.save_answer!(answer)
          @it.next_question!
        end
        expect(@it.questions.map { |question| question[:answer] }).to eq answers
      end
    end

    describe "#next_question!" do
      it "invokes #next_player!" do
        @it.should_receive(:next_player!)
        @it.next_question!
      end

      it "goes to the next question" do
        @it.next_question!
        expect(@it.current_question[:number]).to eq 2
      end
    end

    describe "#next_player!" do
      it "goes to the next player" do
        @it.next_player!
        expect(@it.current_player[:number]).to eq 2

        @it.next_player!
        expect(@it.current_player[:number]).to eq 3

        @it.next_player!
        expect(@it.current_player[:number]).to eq 1
      end
    end

    describe "#finalize!" do
      it "stores the end time" do
        @it.finalize!
        expect(@it.end_time).to be_present
      end
    end
  end

  context "reading" do
    describe "#current_question" do
      it "returns the current question" do
        expect(@it.current_question).to eq({number: 1, id: 2, answer: nil})
        @it.next_question!
        expect(@it.current_question).to eq({number: 2, id: 3, answer: nil})
      end
    end

    describe "#current_player" do
      it "returns the current player" do
        expect(@it.current_player).to eq({number: 1, id: 2})
        @it.next_player!
        expect(@it.current_player).to eq({number: 2, id: 3})
      end
    end

    describe "#quiz" do
      it "returns the quiz" do
        expect(@it.quiz).to eq({id: 2})
      end
    end

    describe "#questions_count" do
      it "returns number of questions" do
        expect(@it.questions_count).to eq 9
      end
    end

    describe "#players_count" do
      it "returns the number of players" do
        expect(@it.players_count).to eq 3
      end
    end

    describe "#begin_time" do
      it "returns a time object" do
        expect(@it.begin_time).to be_a(Time)
      end
    end

    describe "#end_time" do
      before do
        @it.finalize!
      end

      it "returns a time object" do
        expect(@it.end_time).to be_a(Time)
      end
    end
  end

  describe "#over?" do
    it "tells whether the game is over" do
      expect(@it.over?).to be_false

      @it.questions_count.times do
        @it.save_answer!(true)
        @it.next_question!
      end

      expect(@it.over?).to be_true
    end
  end

  describe "#to_h" do
    before do
      @it.finalize!
    end

    it "returns a hash of information" do
      expect(@it.to_h).to be_a(Hash)
    end
  end
end
