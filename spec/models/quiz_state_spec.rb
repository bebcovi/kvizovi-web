require "spec_helper"

describe QuizState do
  before do
    @store = {}
    @it = QuizState.new(@store)
    @quiz_runner = QuizRunner.new(@store)
    @quiz_runner.prepare!(hash)
  end

  let(:hash) {
    {
      quiz_id:      2,
      question_ids: (2..10).to_a,
      student_ids:   (2..4).to_a,
    }
  }

  describe "#current_question" do
    it "returns the current question" do
      expect(@it.current_question).to eq({number: 1, id: 2, answer: nil})
      @quiz_runner.next_question!
      expect(@it.current_question).to eq({number: 2, id: 3, answer: nil})
    end
  end

  describe "#current_student" do
    it "returns the current student" do
      expect(@it.current_student).to eq({number: 1, id: 2})
      @quiz_runner.next_student!
      expect(@it.current_student).to eq({number: 2, id: 3})
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
      expect(@it.students_count).to eq 3
    end
  end

  describe "#begin_time" do
    it "returns a time object" do
      expect(@it.begin_time).to be_a(Time)
    end
  end

  describe "#end_time" do
    it "returns a time object" do
      @quiz_runner.finish!
      expect(@it.end_time).to be_a(Time)
    end
  end

  describe "#to_h" do
    it "returns a hash of information" do
      @quiz_runner.finish!
      expect(@it.to_h).to be_a(Hash)
    end
  end

  describe "#finished?" do
    it "returns true when the last question has been answered" do
      expect(@it.finished?).to be_false
      until @it.current_question == @it.questions.last
        @quiz_runner.save_answer!(true)
        @quiz_runner.next_question!
      end
      expect(@it.finished?).to be_false
      @quiz_runner.save_answer!(true)
      expect(@it.finished?).to be_true
    end
  end
end
