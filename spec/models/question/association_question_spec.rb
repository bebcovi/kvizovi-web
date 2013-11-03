require "spec_helper"

describe AssociationQuestion do
  subject { described_class.new }

  describe "#associations=" do
    it "accepts a hash" do
      subject.associations = {"Foo" => "Foo", "Bar" => "Bar"}
      expect(subject.associations).to eq [["Foo", "Foo"], ["Bar", "Bar"]]
    end

    it "accepts an array" do
      subject.associations = ["Foo", "Foo", "Bar", "Bar"]
      expect(subject.associations).to eq [["Foo", "Foo"], ["Bar", "Bar"]]
    end
  end

  context "#associations" do
    it "must be present" do
      subject.associations = {}
      expect(subject).to have(1).error_on(:associations)
    end

    it "must have pairs with both sides present" do
      subject.associations = {"Foo" => ""}
      expect(subject).to have(1).error_on(:associations)
    end
  end
end
