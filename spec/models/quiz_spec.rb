require "spec_helper"

describe Quiz do
  before do
    @it = build(:quiz)
  end

  it "assigns grades correctly" do
    @it.grades = ["1b", "2a", "3c"]
    @it.grades.should eq ["1b", "2a", "3c"]
  end

  describe "validations" do
  end
end

