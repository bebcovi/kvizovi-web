require "spec_helper"

describe ChoiceQuestion do
  before do
    @it = build(:choice_question)
  end

  describe "#answer" do
    describe "#==" do
      before do
        @it.provided_answers == ["Foo", "Bar", "Baz"]
      end

      it "recognizes a string" do
        expect(@it.answer).to eq "Foo"
      end

      it "is of course false in incorrect answer" do
        expect(@it.answer).not_to eq "wrong answer"
      end
    end
  end

  describe "#randomize!" do
    it "moves the first item somewhere else, since that's the correct answer" do
      @it.randomize!
      expect(@it.provided_answers.first).not_to eq @it.answer
    end

    it "doesn't change the original order" do
      provided_answers = @it.provided_answers.dup
      @it.randomize!
      expect(@it.provided_answers.original).to eq provided_answers
    end

    it "doesn't change the answer" do
      answer = @it.answer.dup
      @it.randomize!
      expect(@it.answer).to eq answer
    end
  end

  context "validations" do
    context "#provided_answers" do
      it "validates presence" do
        expect { @it.provided_answers = [] }.to invalidate(@it)
      end

      it "validates that each provided answer is present" do
        expect { @it.provided_answers = ["Foo", "Bar", ""] }.to invalidate(@it)
      end
    end
  end
end
