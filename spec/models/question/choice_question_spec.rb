require "spec_helper"

describe ChoiceQuestion do
  before do
    @it = Factory.build(:choice_question)
  end

  context "validations" do
    context "#provided_answers" do
      it "validates presence" do
        @it.provided_answers = []
        expect(@it).to have(1).error_on(:provided_answers)
      end

      it "validates that each provided answer is present" do
        @it.provided_answers = ["Foo", "Bar", ""]
        expect(@it).to have(1).error_on(:provided_answers)
      end
    end
  end
end
