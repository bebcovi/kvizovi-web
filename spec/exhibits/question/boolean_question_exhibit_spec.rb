require "spec_helper"

describe BooleanQuestionExhibit do
  before do
    @question = Factory.build(:boolean_question)
    @it = BooleanQuestionExhibit.new(@question)
  end

  describe "#has_answer?" do
    before do
      @question.answer = true
    end

    it "accepts a string" do
      expect(@it).to have_answer("true")
    end

    it "accepts a boolean" do
      expect(@it).to have_answer(true)
    end

    it "can return false" do
      expect(@it).not_to have_answer(false)
    end
  end
end
