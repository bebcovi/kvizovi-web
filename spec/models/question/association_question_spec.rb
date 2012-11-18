require "spec_helper_lite"
use_nulldb { require_relative "../../../app/models/question/association_question" }

describe AssociationQuestion do
  before(:each) { @it = build(:association_question) }
  subject { @it }

  use_nulldb

  it { should be_a(Question) }

  describe "#correct_answer?" do
    it "accepts a hash" do
      @it.correct_answer?(@it.answer).should be_true
    end

    it "accepts a hash-like array" do
      @it.correct_answer?(@it.answer.to_a).should be_true
    end

    it "accepts a flat array" do
      @it.correct_answer?(@it.answer.to_a.flatten).should be_true
    end

    it "is false on incorrect answer" do
      @it.correct_answer?({"Not" => "the right answer"}).should be_false
    end
  end

  describe "data" do
    describe "#associations" do
      it "has left and right side" do
        @it.associations.left_side.should eq @it.associations.keys
        @it.associations.right_side.should eq @it.associations.values
      end

      describe "setter" do
        it "accepts a hash" do
          @it.associations =    {"Foo" => "Foo", "Bar" => "Bar"}
          @it.associations.should eq({"Foo" => "Foo", "Bar" => "Bar"})
        end

        it "accepts a hash-like array" do
          @it.associations =    [["Foo", "Foo"], ["Bar", "Bar"]]
          @it.associations.should eq({"Foo" => "Foo", "Bar" => "Bar"})
        end

        it "accepts a flat array" do
          @it.associations =    ["Foo", "Foo", "Bar", "Bar"]
          @it.associations.should eq({"Foo" => "Foo", "Bar" => "Bar"})
        end

        it "deletes blank pairs" do
          @it.associations =    {"Foo" => "Foo", "" => ""}
          @it.associations.should eq({"Foo" => "Foo"})
          @it.associations =    {"Foo" => "Foo", nil => nil}
          @it.associations.should eq({"Foo" => "Foo"})

          @it.associations =    {"Foo" => "Foo", "Bar" => ""}
          @it.associations.should eq({"Foo" => "Foo", "Bar" => ""})
          @it.associations =    {"Foo" => "Foo", "" => "Bar"}
          @it.associations.should eq({"Foo" => "Foo", "" => "Bar"})
        end

        it "doesn't delete the first pair if it's blank" do
          @it.associations =    {"" => "", "Bar" => "Bar"}
          @it.associations.should eq({"" => "", "Bar" => "Bar"})
        end
      end
    end
  end

  describe "#randomize!" do
    it "shuffles the associations" do
      original_associations = @it.associations.dup
      @it.randomize!.associations.should_not eq original_associations
    end
  end

  describe "validations" do
    it "can't have the first association blank" do
      @it.associations = {"" => "", "Bar" => "Bar"}
      @it.should_not be_valid
    end

    it "has to have full pairs" do
      @it.associations = {"Foo" => ""}
      @it.should_not be_valid
    end
  end
end
