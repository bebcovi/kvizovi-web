require 'spec_helper_lite'
use_nulldb { require_relative "../../app/models/school" }

describe School do
  before(:each) { @it = build(:school) }
  subject { @it }

  use_nulldb

  describe "#public_questions?" do
    it "defaults to true" do
      School.new.public_questions?.should eq true
    end
  end
end
