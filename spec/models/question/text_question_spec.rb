require "spec_helper"

describe TextQuestion do
  before do
    @it = FactoryGirl.build(:text_question)
  end

  context "validations" do
    context "#answer" do
      it "validates presence" do
        @it.answer = ""
        expect(@it).to have(1).error_on(:answer)
      end
    end
  end
end
