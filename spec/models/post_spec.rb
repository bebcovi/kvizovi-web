require "spec_helper"

describe Post do
  before do
    @it = FactoryGirl.build(:post)
  end

  context "validations" do
    context "#title" do
      it "validates presence" do
        @it.title = nil
        expect(@it).to have(1).error_on(:title)
      end
    end

    context "#body" do
      it "validates presence" do
        @it.body = nil
        expect(@it).to have(1).error_on(:body)
      end
    end
  end
end
