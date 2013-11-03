require "spec_helper"

describe Question do
  subject { described_class.new }

  describe "#content" do
    it "must be present" do
      subject.content = nil
      expect(subject).to have(1).error_on(:content)
    end
  end
end
