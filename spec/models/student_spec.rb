require 'spec_helper_lite'
require_relative "../../app/models/student"

describe Student do
  before(:each) { @it = build(:student, school_id: 1) }
  subject { @it }

  before(:each) { stub_const("School", Class.new) }

  use_nulldb

  it "belongs to a school" do
    @it.should respond_to(:school)
  end

  it "has a full name" do
    @it.full_name.should eq "#{@it.first_name} #{@it.last_name}"
  end

  it "can authenticate" do
    @it.authenticate(attributes_for(:student)[:password]).should be_true
    @it.authenticate("").should be_false
  end

  describe "validations" do
    it "validates school key" do
      @it.school_id = nil
      School.stub(:find_by_key) { nil }
      @it.should_not be_valid
    end

    it "validates format of username" do
      @it.username = "@@@"
      @it.should_not be_valid
    end

    it "validates length of username" do
      @it.username = "ab"
      @it.should_not be_valid
    end
  end
end
