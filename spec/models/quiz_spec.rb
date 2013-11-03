require "spec_helper"

describe Quiz do
  subject { described_class.new }

  context "#name" do
    it "must be present" do
      subject.name = nil
      expect(subject).to have(1).error_on(:name)
    end

    it "must be unique inside a school" do
      create(:quiz, name: "Foo", school_id: 1)
      subject.assign_attributes(name: "Foo", school_id: 1)
      expect(subject).to have(1).error_on(:name)
    end
  end
end
