require "spec_helper"
require "set"

describe AssociationQuestionExhibit do
  before do
    @question = Factory.build(:association_question)
    @it = AssociationQuestionExhibit.new(@question)
  end

  describe "#associations" do
    it "shuffles the underlying associations" do
      expect(Set.new(@it.associations.keys)).to eq Set.new(@question.associations.keys)
      expect(Set.new(@it.associations.values)).to eq Set.new(@question.associations.values)
      expect(@it.associations).not_to eq @question.associations
    end
  end

  describe "#has_answer?" do
    before do
      @question.associations = {"Foo" => "Foo", "Bar" => "Bar", "Baz" => "Baz"}
    end

    it "accepts an array" do
      expect(@it).to have_answer(["Foo", "Foo", "Bar", "Bar", "Baz", "Baz"])
    end

    it "accepts a hash" do
      expect(@it).to have_answer({"Foo" => "Foo", "Bar" => "Bar", "Baz" => "Baz"})
    end

    it "can return false" do
      expect(@it).not_to have_answer({"Foo" => "Bar", "Bar" => "Foo", "Baz" => "Baz"})
    end
  end
end
