require "spec_helper"

describe QuestionShuffling do
  describe ".new" do
    it "instantiates the appropriate exhibit" do
      exhibit = described_class.new(BooleanQuestion.new)
      expect(exhibit).to be_a(BooleanQuestionShuffling)
    end
  end
end

describe AssociationQuestionShuffling do
  subject { described_class.new(question) }
  let(:question) { build(:association_question) }

  describe "#associations" do
    before do
      question.associations = {"Foo" => "Foo", "Bar" => "Bar", "Baz" => "Baz"}
    end

    it "shuffles the underlying associations" do
      expect(subject.associations.map(&:first)).to match_array(question.associations.map(&:first))
      expect(subject.associations.map(&:last)).to match_array(question.associations.map(&:last))
      expect(subject.associations).not_to eq question.associations
    end
  end
end

describe ChoiceQuestionShuffling do
  subject { described_class.new(question) }
  let(:question) { build(:choice_question) }

  describe "#provided_answers" do
    before do
      question.provided_answers = ["Foo", "Bar", "Baz"]
    end

    it "shuffles the underlying provided answers" do
      expect(subject.provided_answers).to match_array(question.provided_answers)
      expect(subject.provided_answers.first).not_to eq question.provided_answers.first
    end
  end
end

describe BooleanQuestionShuffling do
  subject { described_class.new(question) }
  let(:question) { build(:boolean_question) }
end

describe TextQuestionShuffling do
  subject { described_class.new(question) }
  let(:question) { build(:text_question) }
end
