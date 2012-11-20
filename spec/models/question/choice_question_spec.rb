require "spec_helper_lite"
use_nulldb { require_relative "../../../app/models/question/choice_question" }

describe ChoiceQuestion do
  before(:each) { @it = build(:choice_question) }
  subject { @it }

  use_nulldb

  it { should be_a(Question) }

  describe "#answer" do
    it "should be the first provided answer" do
      @it.answer.should eq @it.provided_answers.first
    end
  end

  describe "#has_answer?" do
    it "accepts a string" do
      @it.correct_answer?(@it.answer).should be_true
    end

    it "is false on incorrect answer" do
      @it.correct_answer?("Not the right answer").should be_false
    end
  end

  describe "data" do
    describe "#provided_answers" do
      describe "setter" do
        it "accepts an array" do
          @it.provided_answers =         ["Foo", "Bar"]
          @it.provided_answers.should eq ["Foo", "Bar"]
        end

        it "deletes blank elements" do
          @it.provided_answers =         ["Foo", "Bar", "", ""]
          @it.provided_answers.should eq ["Foo", "Bar"]

          @it.provided_answers =         ["Foo", "Bar", nil, nil]
          @it.provided_answers.should eq ["Foo", "Bar"]
        end

        it "doesn't delete the first element if it's blank" do
          @it.provided_answers =         ["", "Bar", "Baz"]
          @it.provided_answers.should eq ["", "Bar", "Baz"]
        end
      end
    end
  end

  describe "#randomize" do
    it "doesn't put the correct answer at the first place" do
      answer = @it.answer
      @it.randomize!.provided_answers.first.should_not eq answer
    end
  end

  describe "validations" do
    it "can't have the first provided answer blank" do
      @it.provided_answers = ["", "Bar", "Baz"]
      @it.should_not be_valid
    end
  end
end
