require "spec_helper"

describe Password do
  before do
    @user = build(:school)
    @it = Password.new(
      user: @user,
      old: @user.password,
      new: "new password",
      new_confirmation: "new password",
    )
  end

  context "validations" do
    context "#old" do
      it "validates that it matches the current one" do
        expect { @it.old = "wrong password" }.to invalidate(@it)
      end
    end

    context "#new" do
      before do
        @user.stub(:authenticate).and_return(true)
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
