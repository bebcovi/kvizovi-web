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
      expect(subject.correct_answer?([["Foo", "Foo"], ["Bar", "Bar"], ["Baz", "Baz"]])).to be true
    end

    it "ignores the order" do
      expect(subject.correct_answer?([["Bar", "Bar"], ["Foo", "Foo"], ["Baz", "Baz"]])).to be true
    end

    it "accepts a hash" do
      expect(subject.correct_answer?({"Foo" => "Foo", "Bar" => "Bar", "Baz" => "Baz"})).to be true
    end

    it "can return false" do
      expect(subject.correct_answer?({"Foo" => "Bar", "Bar" => "Foo", "Baz" => "Baz"})).to be false
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
      expect(subject.correct_answer?("Foo")).to be true
    end

    it "can return false" do
      expect(subject.correct_answer?("Bar")).to be false
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
      expect(subject.correct_answer?(true)).to be true
    end

    it "can return false" do
      expect(subject.correct_answer?(false)).to be false
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
      expect(subject.correct_answer?("answer")).to be true
    end

    it "ignores whitespace at the ends" do
      expect(subject.correct_answer?("  Answer    ")).to be true
      expect(subject.correct_answer?("An swer")).to be false
    end

    it "ignores a potential dot at the end" do
      expect(subject.correct_answer?("Answer.")).to be true
    end

    it "transliterates special characters" do
      expect(subject.correct_answer?("Anšwer")).to be true
    end

    it "accepts nil" do
      expect(subject.correct_answer?(nil)).to be false
    end

    it "can return false" do
      expect(subject.correct_answer?("Not answer")).to be false
    end
  end
end
