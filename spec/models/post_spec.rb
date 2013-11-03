require "spec_helper"

describe Post do
  subject { described_class.new }

  describe "#title" do
    it "must be present" do
      subject.title = nil
      expect(subject).to have(1).error_on(:title)
    end
  end

  describe "#body" do
    it "must be present" do
      subject.body = nil
      expect(subject).to have(1).error_on(:body)
    end
  end
end
