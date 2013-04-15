require "spec_helper"

describe AssociationQuestionExhibit do
  before do
    @question = Factory.build(:association_question)
    @it = AssociationQuestionExhibit.new(@question)
  end

  describe "#associations" do
    it "shuffles the underlying associations" do
      expect(@it.associations.keys).to match_array(@question.associations.keys)
      expect(@it.associations.values).to match_array(@question.associations.values)
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
