require "spec_helper"

describe PasswordResetter do
  before do
    @user = create(:school)
    @it = PasswordResetter.new(@user)
  end

  describe "#reset_password" do
    it "resets the user's password" do
      expect {
        @it.reset_password
      }.to change{@user.reload.password_digest}
    end
  end
end
