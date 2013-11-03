require "spec_helper"

describe BooleanQuestion do
  subject { described_class.new }

  describe "#answer=" do
    it "accepts a boolean" do
      subject.answer = true
      expect(subject.answer).to eq true
    end

    it "accepts a string" do
      subject.answer = "true"
      expect(subject.answer).to eq true
    end
  end

  context "#answer" do
    it "must be present" do
      subject.answer = nil
      expect(subject).to have(1).error_on(:answer)
    end

    it "must be a boolean" do
      subject.answer = double
      expect(subject).to have(1).error_on(:answer)
    end
  end
end
