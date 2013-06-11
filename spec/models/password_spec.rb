require "spec_helper"

describe Password do
  before do
    @it = Password.new
  end

  context "validations" do
    before do
      @it.user = FactoryGirl.build(:school, password: "secret")
    end

    context "#old" do
      it "validates that it matches the current one" do
        @it.old = "wrong password"
        expect(@it).to have(1).error_on(:old)
      end
    end

    context "#new" do
      it "validates presence" do
        @it.new = nil
        expect(@it).to have(1).error_on(:new)
      end

      it "validates confirmation" do
        @it.new = "secret"
        @it.new_confirmation = "wrong confirmation"
        expect(@it).to have(1).error_on(:new)
      end
    end
  end
end
