require "spec_helper"

describe QuizRunner do
  before do
    @store = {}
    @it = QuizRunner.new(@store)
    @quiz_state = QuizState.new(@store)
    @it.prepare!(hash)
  end

  let(:hash) {
    {
      quiz_id:      2,
      question_ids: (2..10).to_a,
      student_ids:  (2..4).to_a,
    }
  }

  describe "#prepare!" do
    it "stores the begin time" do
      expect(@quiz_state.begin_time).to be_present
    end
  end

  describe "#save_answer!" do
    it "saves the answer" do
      answers = @quiz_state.questions.map { [true, false].sample }
      answers.each do |answer|
        @it.save_answer!(answer)
        @it.next_question!
      end
      expect(@quiz_state.questions.map { |q| q[:answer] }).to eq answers
    end
  end

  describe "#next_question!" do
    it "changes the student" do
      expect do
        @it.next_question!
      end.to change { @quiz_state.current_student[:number] }.by 1
    end

    it "goes to the next question" do
      expect do
        @it.next_question!
      end.to change { @quiz_state.current_question[:number] }.by 1
    end
  end

  describe "#next_student!" do
    it "goes to the next student" do
      expect { @it.next_student! }.to \
        change { @quiz_state.current_student[:number] }.from(1).to(2)
      expect { @it.next_student! }.to \
        change { @quiz_state.current_student[:number] }.from(2).to(3)
      expect { @it.next_student! }.to \
        change { @quiz_state.current_student[:number] }.from(3).to(1)
    end
  end

  describe "#finish!" do
    it "stores the end time" do
      @it.finish!
      expect(@quiz_state.end_time).to be_present
    end
  end
end
