require "spec_helper"

describe AssociationQuestion do
  before do
    @it = build(:association_question)
  end

  describe "#associations" do
    it "has left and right side" do
      @it.associations.left_side.should eq @it.associations.keys
      @it.associations.right_side.should eq @it.associations.values
    end

    it "accepts a hash" do
      @it.associations = {"Foo" => "Foo", "Bar" => "Bar"}
      expect(@it.associations).to eq({"Foo" => "Foo", "Bar" => "Bar"})
    end

    it "accepts a hash-like array" do
      @it.associations = [["Foo", "Foo"], ["Bar", "Bar"]]
      expect(@it.associations).to eq({"Foo" => "Foo", "Bar" => "Bar"})
    end

    it "accepts a flat array" do
      @it.associations = ["Foo", "Foo", "Bar", "Bar"]
      expect(@it.associations).to eq({"Foo" => "Foo", "Bar" => "Bar"})
    end
  end

  describe "#answer" do
    describe "#==" do
      before do
        @it.associations = {"Foo" => "Foo", "Bar" => "Bar"}
      end

      it "recognizes Associations" do
        expect(@it.answer).to eq @it.associations
      end

      it "recognizes a hash" do
        expect(@it.answer).to eq({"Foo" => "Foo", "Bar" => "Bar"})
      end

      it "recognizes hash-like array" do
        expect(@it.answer).to eq [["Foo", "Foo"], ["Bar", "Bar"]]
      end

      it "recognizes a flat array" do
        expect(@it.answer).to eq ["Foo", "Foo", "Bar", "Bar"]
      end

      it "is of course false on incorrect answer" do
        expect(@it.answer).not_to eq({"Foo" => "Bar", "Bar" => "Foo"})
      end
    end
  end

  describe "#randomize!" do
    it "shuffles the associations" do
      @it.randomize!
      expect(@it.answer).not_to eq @it.associations
    end

    it "doesn't change the answer" do
      answer = @it.answer.dup
      @it.randomize!
      expect(@it.answer).to eq answer
    end
  end

  context "validations" do
    context "#associations" do
      it "validates presence" do
        expect { @it.associations = {} }.to invalidate(@it)
      end

      it "validates that the both sides of a pair is present" do
        expect { @it.associations = {"Foo" => ""} }.to invalidate(@it)
      end
    end
  end
end
