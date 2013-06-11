require "spec_helper"

describe Question do
  before do
    @it = Question.new
  end

  context "validations" do
    context "#content" do
      it "validates presence" do
        @it.content = nil
        expect(@it).to have(1).error_on(:content)
      end
    end
  end
end
