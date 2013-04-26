require "spec_helper"

describe QuestionShuffling do
  describe ".new" do
    it "instantiates the appropriate exhibit" do
      exhibit = QuestionShuffling.new(BooleanQuestion.new)
      expect(exhibit).to be_a(BooleanQuestionShuffling)
    end
  end
end

describe AssociationQuestionShuffling do
  before do
    @question = Factory.build(:association_question)
    @it = AssociationQuestionShuffling.new(@question)
  end

  describe "#associations" do
    before do
      @question.associations = {"Foo" => "Foo", "Bar" => "Bar", "Baz" => "Baz"}
    end

    it "shuffles the underlying associations" do
      expect(@it.associations.keys).to match_array(@question.associations.keys)
      expect(@it.associations.values).to match_array(@question.associations.values)
      expect(@it.associations).not_to eq @question.associations
    end
  end
end

describe ChoiceQuestionShuffling do
  before do
    @question = Factory.build(:choice_question)
    @it = ChoiceQuestionShuffling.new(@question)
  end

  describe "#provided_answers" do
    before do
      @question.provided_answers = ["Foo", "Bar", "Baz"]
    end

    it "shuffles the underlying provided answers" do
      expect(@it.provided_answers).to match_array(@question.provided_answers)
      expect(@it.provided_answers.first).not_to eq @question.provided_answers.first
    end
  end
end

describe BooleanQuestionShuffling do
  before do
    @question = Factory.build(:boolean_question)
    @it = BooleanQuestionShuffling.new(@question)
  end
end

describe TextQuestionShuffling do
  before do
    @question = Factory.build(:text_question)
    @it = TextQuestionShuffling.new(@question)
  end
end

describe ImageQuestionShuffling do
  before do
    @question = Factory.build(:image_question)
    @it = ImageQuestionShuffling.new(@question)
  end

  it "inherits from TextQuestionShuffling" do
    expect(@it).to be_a(TextQuestionShuffling)
  end
end
