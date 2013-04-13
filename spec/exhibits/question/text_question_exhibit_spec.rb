require "spec_helper"

describe TextQuestionExhibit do
  before do
    @question = Factory.build(:text_question)
    @it = TextQuestionExhibit.new(@question)
  end

  describe "#has_answer?" do
    before do
      @question.answer = "Answer"
    end

    it "is case insensitive" do
      expect(@it).to have_answer("answer")
    end

    it "ignores whitespace at the ends" do
      expect(@it).to have_answer("  Answer    ")
      expect(@it).not_to have_answer("An swer")
    end

    it "ignores a potential dot at the end" do
      expect(@it).to have_answer("Answer.")
    end

    it "transliterates special characters" do
      expect(@it).to have_answer("Anšwer")
    end

    it "can return false" do
      expect(@it).not_to have_answer("Not answer")
    end
  end
end
