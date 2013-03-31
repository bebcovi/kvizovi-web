require "spec_helper"

describe Question do
  before(:all) do
    @it = build(:question)
  end

  context "validations" do
    reset_attributes(FactoryGirl.build(:question))

    context "#content" do
      it "validates presence" do
        expect { @it.content = nil }.to invalidate(@it)
      end
    end
  end
end
