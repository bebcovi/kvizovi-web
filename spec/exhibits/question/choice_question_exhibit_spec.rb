require "spec_helper"

describe ChoiceQuestionExhibit do
  before do
    @question = Factory.build(:choice_question)
    @it = ChoiceQuestionExhibit.new(@question)
  end

  describe "#provided_answers" do
    it "shuffles the underlying provided answers" do
      expect(@it.provided_answers).to match_array(@question.provided_answers)
      expect(@it.provided_answers.first).not_to eq @question.provided_answers.first
    end
  end

  describe "#has_answer?" do
    before do
      @question.provided_answers = ["Foo", "Bar", "Baz"]
    end

    it "compares it to the first provided answer" do
      expect(@it).to have_answer("Foo")
    end

    it "can return false" do
      expect(@it).not_to have_answer("Bar")
    end
  end
end
