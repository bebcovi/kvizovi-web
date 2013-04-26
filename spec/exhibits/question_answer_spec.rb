require "spec_helper"

describe QuestionAnswer do
  describe ".new" do
    it "instantiates the appropriate exhibit" do
      exhibit = QuestionAnswer.new(BooleanQuestion.new)
      expect(exhibit).to be_a(BooleanQuestionAnswer)
    end
  end
end

describe AssociationQuestionAnswer do
  before do
    @question = Factory.build(:association_question)
    @it = AssociationQuestionAnswer.new(@question)
  end

  describe "#correct_answer?" do
    before do
      @question.associations = {"Foo" => "Foo", "Bar" => "Bar", "Baz" => "Baz"}
    end

    it "accepts an array" do
      expect(@it.correct_answer?(["Foo", "Foo", "Bar", "Bar", "Baz", "Baz"])).to be_true
    end

    it "accepts a hash" do
      expect(@it.correct_answer?({"Foo" => "Foo", "Bar" => "Bar", "Baz" => "Baz"})).to be_true
    end

    it "can return false" do
      expect(@it.correct_answer?({"Foo" => "Bar", "Bar" => "Foo", "Baz" => "Baz"})).to be_false
    end
  end
end

describe ChoiceQuestionAnswer do
  before do
    @question = Factory.build(:choice_question)
    @it = ChoiceQuestionAnswer.new(@question)
  end

  describe "#correct_answer?" do
    before do
      @question.provided_answers = ["Foo", "Bar", "Baz"]
    end

    it "compares it to the first provided answer" do
      expect(@it.correct_answer?("Foo")).to be_true
    end

    it "can return false" do
      expect(@it.correct_answer?("Bar")).to be_false
    end
  end
end

describe BooleanQuestionAnswer do
  before do
    @question = Factory.build(:boolean_question)
    @it = BooleanQuestionAnswer.new(@question)
  end

  describe "#correct_answer?" do
    before do
      @question.answer = true
    end

    it "accepts a string" do
      expect(@it.correct_answer?("true")).to be_true
    end

    it "accepts a boolean" do
      expect(@it.correct_answer?(true)).to be_true
    end

    it "can return false" do
      expect(@it.correct_answer?(false)).to be_false
    end
  end
end

describe TextQuestionAnswer do
  before do
    @question = Factory.build(:text_question)
    @it = TextQuestionAnswer.new(@question)
  end

  describe "#correct_answer?" do
    before do
      @question.answer = "Answer"
    end

    it "is case insensitive" do
      expect(@it.correct_answer?("answer")).to be_true
    end

    it "ignores whitespace at the ends" do
      expect(@it.correct_answer?("  Answer    ")).to be_true
      expect(@it.correct_answer?("An swer")).to be_false
    end

    it "ignores a potential dot at the end" do
      expect(@it.correct_answer?("Answer.")).to be_true
    end

    it "transliterates special characters" do
      expect(@it.correct_answer?("Anšwer")).to be_true
    end

    it "can return false" do
      expect(@it.correct_answer?("Not answer")).to be_false
    end
  end
end

describe ImageQuestionAnswer do
  before do
    @question = Factory.build(:text_question)
    @it = ImageQuestionAnswer.new(@question)
  end

  it "inherits from TextQuestionAnswer" do
    expect(@it).to be_a(TextQuestionAnswer)
  end
end
