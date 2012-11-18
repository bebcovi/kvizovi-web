require "spec_helper_lite"
use_nulldb { require_relative "../../../app/models/question/boolean_question" }

describe BooleanQuestion do
  before(:each) { @it = build(:boolean_question) }
  subject { @it }

  use_nulldb

  it { should be_a(Question) }

  it "should be true or false" do
    @it.true?.should be_true
    @it.false?.should be_false
  end

  describe "#correct_answer?" do
    it "recognizes both string and boolean argument" do
      @it.answer = true
      @it.correct_answer?(true).should be_true
      @it.correct_answer?("true").should be_true

      @it.answer = false
      @it.correct_answer?(false).should be_true
      @it.correct_answer?("false").should be_true
    end

    it "is false on incorrect answer" do
      @it.correct_answer?(!@it.answer).should be_false
    end
  end

  describe "validations" do
    it "can't have blank answer" do
      @it.answer = nil
      @it.should_not be_valid
    end
  end
end
