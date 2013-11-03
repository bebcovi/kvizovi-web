require "spec_helper"

describe QuestionAnswer do
  describe ".new" do
    it "instantiates the appropriate exhibit" do
      exhibit = described_class.new(BooleanQuestion.new)
      expect(exhibit).to be_a(BooleanQuestionAnswer)
    end
  end
end

describe AssociationQuestionAnswer do
  subject { described_class.new(question) }
  let(:question) { build(:association_question) }

  describe "#correct_answer?" do
    before do
      question.associations = {"Foo" => "Foo", "Bar" => "Bar", "Baz" => "Baz"}
    end

    it "accepts an array" do
      expect(subject.correct_answer?([["Foo", "Foo"], ["Bar", "Bar"], ["Baz", "Baz"]])).to be_true
    end

    it "ignores the order" do
      expect(subject.correct_answer?([["Bar", "Bar"], ["Foo", "Foo"], ["Baz", "Baz"]])).to be_true
    end

    it "accepts a hash" do
      expect(subject.correct_answer?({"Foo" => "Foo", "Bar" => "Bar", "Baz" => "Baz"})).to be_true
    end

    it "can return false" do
      expect(subject.correct_answer?({"Foo" => "Bar", "Bar" => "Foo", "Baz" => "Baz"})).to be_false
    end
  end
end

describe ChoiceQuestionAnswer do
  subject { described_class.new(question) }
  let(:question) { build(:choice_question) }

  describe "#correct_answer?" do
    before do
      question.provided_answers = ["Foo", "Bar", "Baz"]
    end

    it "compares it to the first provided answer" do
      expect(subject.correct_answer?("Foo")).to be_true
    end

    it "can return false" do
      expect(subject.correct_answer?("Bar")).to be_false
    end
  end
end

describe BooleanQuestionAnswer do
  subject { described_class.new(question) }
  let(:question) { build(:boolean_question) }

  describe "#correct_answer?" do
    before do
      question.answer = true
    end

    it "accepts a boolean" do
      expect(subject.correct_answer?(true)).to be_true
    end

    it "can return false" do
      expect(subject.correct_answer?(false)).to be_false
    end
  end
end

describe TextQuestionAnswer do
  subject { described_class.new(question) }
  let(:question) { build(:text_question) }

  describe "#correct_answer?" do
    before do
      question.answer = "Answer"
    end

    it "is case insensitive" do
      expect(subject.correct_answer?("answer")).to be_true
    end

    it "ignores whitespace at the ends" do
      expect(subject.correct_answer?("  Answer    ")).to be_true
      expect(subject.correct_answer?("An swer")).to be_false
    end

    it "ignores a potential dot at the end" do
      expect(subject.correct_answer?("Answer.")).to be_true
    end

    it "transliterates special characters" do
      expect(subject.correct_answer?("Anšwer")).to be_true
    end

    it "accepts nil" do
      expect(subject.correct_answer?(nil)).to be_false
    end

    it "can return false" do
      expect(subject.correct_answer?("Not answer")).to be_false
    end
  end
end
