require "spec_helper"

describe BooleanQuestion do
  before do
    @it = FactoryGirl.build(:boolean_question)
  end

  describe "#answer=" do
    it "accepts a boolean" do
      @it.answer = true
      expect(@it.answer).to eq true
    end

    it "accepts a string" do
      @it.answer = "true"
      expect(@it.answer).to eq true
    end
  end

  context "validations" do
    context "#answer" do
      it "validates presence" do
        @it.answer = nil
        expect(@it).to have(1).error_on(:answer)
      end

      it "validates inclusion" do
        @it.answer = double
        expect(@it).to have(1).error_on(:answer)
      end
    end
  end
end
