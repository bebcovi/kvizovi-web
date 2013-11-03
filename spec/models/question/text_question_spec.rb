require "spec_helper"

describe TextQuestion do
  subject { described_class.new }

  context "#answer" do
    it "must be present" do
      subject.answer = ""
      expect(subject).to have(1).error_on(:answer)
    end
  end
end
