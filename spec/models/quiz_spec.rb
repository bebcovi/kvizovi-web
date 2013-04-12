require "spec_helper"

describe Quiz do
  before do
    @it = Factory.build(:empty_quiz)
  end

  context "validations" do
    context "#name" do
      it "validates presence" do
        @it.name = nil
        expect(@it).to have(1).error_on(:name)
      end
    end

    context "#school_id" do
      it "validates presence" do
        @it.school_id = nil
        expect(@it).to have(1).error_on(:school_id)
      end
    end
  end
end

