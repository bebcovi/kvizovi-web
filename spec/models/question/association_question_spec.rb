require "spec_helper"

describe AssociationQuestion do
  before do
    @it = Factory.build(:association_question)
  end

  describe "#associations=" do
    it "accepts a hash" do
      @it.associations = {"Foo" => "Foo", "Bar" => "Bar"}
      expect(@it.associations).to eq({"Foo" => "Foo", "Bar" => "Bar"})
    end

    it "accepts an array" do
      @it.associations = ["Foo", "Foo", "Bar", "Bar"]
      expect(@it.associations).to eq({"Foo" => "Foo", "Bar" => "Bar"})
    end
  end

  context "validations" do
    context "#associations" do
      it "validates presence" do
        @it.associations = {}
        expect(@it).to have(1).error_on(:associations)
      end

      it "validates that the both sides of a pair is present" do
        @it.associations = {"Foo" => ""}
        expect(@it).to have(1).error_on(:associations)
      end
    end
  end
end
