require "spec_helper"

describe ChoiceQuestion do
  subject { described_class.new }

  context "#provided_answers" do
    it "must be present" do
      subject.provided_answers = []
      expect(subject).to have(1).error_on(:provided_answers)
    end

    it "must have each provided answer present" do
      subject.provided_answers = ["Foo", "Bar", ""]
      expect(subject).to have(1).error_on(:provided_answers)
    end
  end
end
