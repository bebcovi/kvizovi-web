require "spec_helper"

describe Quiz do
  before(:all) do
    @it = build(:quiz)
  end

  context "validations" do
    reset_attributes(FactoryGirl.attributes_for(:quiz))

    context "#name" do
      it "validates presence" do
        expect { @it.name = nil }.to invalidate(@it)
      end
    end

    context "#school_id" do
      it "validates presence" do
        expect { @it.school_id = nil }.to invalidate(@it)
      end
    end
  end
end

