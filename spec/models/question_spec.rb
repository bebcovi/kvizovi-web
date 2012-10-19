require "spec_helper_lite"
require_relative "../../app/models/question"

describe Question do
  before(:each) { @it = build(:boolean_question) }
  subject { @it }

  use_nulldb

  it "belongs to a quiz" do
    @it.should respond_to(:quiz)
  end

  its(:category) { should eq "boolean" }

  describe "#hint" do
    it "has a getter and a setter" do
      @it.hint = "Hint"
      @it.hint.should eq "Hint"
    end
  end

  describe "validations" do
    it "can't have blank content" do
      @it.content = nil
      @it.should_not be_valid
    end
  end
end
