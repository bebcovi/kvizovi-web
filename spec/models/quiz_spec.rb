require 'spec_helper_lite'
require_relative "../../app/models/quiz"

describe Quiz do
  before(:each) { @it = build(:quiz) }
  subject { @it }

  use_nulldb

  it "removes blanks and converts to integer when assigning grades" do
    @it.grades = ["1", "", "2"]
    @it.grades.should eq [1, 2]
  end
end
