require "spec_helper"

describe QuestionExhibit do
  describe ".new" do
    it "instantiates the appropriate exhibit" do
      exhibit = QuestionExhibit.new(BooleanQuestion.new)
      expect(exhibit).to be_a(BooleanQuestionExhibit)
    end
  end
end
