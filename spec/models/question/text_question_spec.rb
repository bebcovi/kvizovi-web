require "spec_helper_lite"
use_nulldb { require_relative "../../../app/models/question/text_question" }

describe TextQuestion do
  before(:each) { @it = build(:text_question) }
  subject { @it }

  use_nulldb

  it { should be_a(Question) }

  describe "#has_answer?" do
    before(:each) { @it.answer = "Answer" }

    it "is case insensitive" do
      @it.correct_answer?("answer").should be_true
    end

    it "ignores a potential period at the end" do
      @it.correct_answer?("Answer.").should be_true
    end

    it "is false on incorrect answer" do
      @it.correct_answer?("Not the right answer").should be_false
    end

    it "ignores whitespace at the beginning and the end of answers" do
      @it.correct_answer?(" Answer  ").should be_true
    end
  end

  describe "validations" do
    it "can't have blank answer" do
      @it.answer = nil
      @it.should_not be_valid
    end
  end
end
