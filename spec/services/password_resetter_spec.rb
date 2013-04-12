require "spec_helper"

describe PasswordResetter do
  before do
    @user = Factory.create_without_validation(:empty_school)
    @it = PasswordResetter.new(@user)
  end

  describe "#reset_password" do
    it "resets the password" do
      @user.stub(:valid?) { true }
      expect {
        @it.reset_password
      }.to change { @user.reload.password_digest }
    end
  end
end
