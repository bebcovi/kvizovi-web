require "spec_helper"

describe PasswordResetter do
  before do
    @user = Factory.create(:user)
    @it = PasswordResetter.new(@user)
  end

  describe "#reset_password" do
    it "resets the password" do
      expect do
        @it.reset_password
      end.to change { @user.reload.password_digest }
    end
  end
end
