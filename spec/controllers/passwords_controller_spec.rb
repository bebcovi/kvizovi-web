require "spec_helper"

describe PasswordsController, user: :school do
  before do
    @user = Factory.create(:user)
    login_as(@user)
  end

  describe "#edit" do
    it "doesn't raise errors" do
      get :edit
    end
  end

  describe "#update" do
    context "when valid" do
      before do
        Password.any_instance.stub(:valid?) { true }
      end

      it "updates the password" do
        post :update, password: {new: "new password"}
        expect(@user.reload.authenticate("new password")).to be_true
      end
    end

    context "when invalid" do
      before do
        Password.any_instance.stub(:valid?) { false }
      end

      it "doesn't raise errors" do
        post :update
      end
    end
  end
end
