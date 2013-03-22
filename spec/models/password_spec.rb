require "spec_helper"

describe Password do
  before do
    @it = Password.new(
      user: stub,
      old: "old password",
      new: "new password",
      new_confirmation: "new password",
    )
  end

  context "validations" do
    context "#old" do
      it "validates that it matches the current one" do
        @it.old = "wrong password"
        @it.user.stub(:authenticate).with("wrong password").and_return(false)
        expect(@it).not_to be_valid
      end
    end

    context "#new" do
      before do
        @it.user.stub(:authenticate).and_return(true)
      end

      it "validates presence" do
        expect { @it.new = nil }.to invalidate(@it)
      end

      it "validates confirmation" do
        expect { @it.new_confirmation = "wrong password" }.to invalidate(@it)
      end
    end
  end
end
