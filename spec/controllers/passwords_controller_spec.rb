require "spec_helper"

describe PasswordsController, user: :school do
  before do
    @user = FactoryGirl.create(:school)
    login_as(@user)
  end

  describe "#edit" do
    it "doesn't raise errors" do
      get :edit
    end
  end

  describe "#update" do
    context "when valid" do
      before { valid!(Password) }

      it "updates the password" do
        post :update, password: {new: "new password"}
        expect(@user.reload.authenticate("new password")).to be_true
      end
    end

    context "when invalid" do
      before { invalid!(Password) }

      it "doesn't raise errors" do
        post :update, password: {new: nil}
      end
    end
  end
end
