require "spec_helper"

describe PasswordResetService do
  before do
    @user = FactoryGirl.create(:school)
    @it = PasswordResetService.new(@user)
  end

  describe "#reset_password" do
    it "resets the password" do
      expect do
        @it.reset_password
      end.to change{@user.reload.password_digest}
    end
  end

  describe "#generate_confirmation_id" do
    it "generates a confirmation ID" do
      expect do
        @it.generate_confirmation_id
      end.to change{@user.reload.password_reset_confirmation_id}
    end
  end
end
