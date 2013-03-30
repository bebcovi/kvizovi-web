require "spec_helper"

describe Question do
  before do
    @it = build(:question)
  end

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
