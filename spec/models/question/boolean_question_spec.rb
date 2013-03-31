require "spec_helper"

describe BooleanQuestion do
  before do
    @it = build(:boolean_question)
  end

  describe "#answer" do
    it "accepts boolean" do
      @it.answer = true
      expect(@it.answer).to eq true
    end

    it "accepts string" do
      @it.answer = "true"
      expect(@it.answer).to eq true
    end

    describe "#==" do
      before do
        @it.answer = true
      end

      it "recognizes a boolean" do
        expect(@it.answer).to eq true
      end

      it "recognizes a string" do
        expect(@it.answer).to eq "true"
      end

      it "is of course false on incorrect answer" do
        expect(@it.answer).not_to eq false
      end
    end
  end

  context "validations" do
    context "#answer" do
      it "validates presence" do
        expect { @it.answer = nil }.to invalidate(@it)
      end

      it "validates inclusion" do
        expect { @it.answer = stub }.to invalidate(@it)
      end
    end
  end
end
