require "spec_helper_lite"
use_nulldb { require_relative "../../app/models/quiz" }

describe Quiz do
  before(:each) { @it = build(:quiz) }
  subject { @it }

  use_nulldb

  it "assigns grades correctly" do
    @it.grades = ["1b", "2a", "3c"]
    @it.grades.should eq ["1b", "2a", "3c"]
  end

  describe "validations" do
  end
end

