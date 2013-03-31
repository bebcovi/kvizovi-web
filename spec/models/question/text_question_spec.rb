require "spec_helper"

describe TextQuestion do
  before do
    @it = build(:text_question)
  end

  describe "#answer" do
    describe "#==" do
      before do
        @it.answer = "Answer"
      end

      it "is of course true on correct answer" do
        expect(@it.answer).to eq "Answer"
      end

      it "is case insensitive" do
        expect(@it.answer).to eq "answer"
      end

      it "ignores a potential period at the end" do
        expect(@it.answer).to eq "Answer."
      end

      it "ignores whitespace at the beginning and the end of answers" do
        expect(@it.answer).to eq "  Answer  "
      end

      it "is of course false on incorrect answer" do
        expect(@it.answer).not_to eq "Not answer"
      end
    end
  end

  context "validations" do
    context "#answer" do
      it "validates presence" do
        expect { @it.answer = "" }.to invalidate(@it)
      end
    end
  end
end
