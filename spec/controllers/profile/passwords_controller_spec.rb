require "spec_helper"

describe Profile::PasswordsController do
  describe "#edit" do
    it "renders :edit" do
      get :edit
      expect(response).to render_template(:edit)
    end
  end

  describe "#update" do
    before do
      @user = stub
      controller.stub(:current_user).and_return(@user)
    end

    context "when valid" do
      before do
        Password.any_instance.stub(:valid?).and_return(true)
        @user.stub(:update_attributes)
      end

      it "updates the password" do
        @user.should_receive(:update_attributes).with(password: "secret")
        put :update, password: {new: "secret"}
      end

      it "redirects to profile" do
        put :update
        expect(response).to redirect_to(profile_path)
      end

      it "sets a flash message" do
        put :update
        expect(flash[:notice]).not_to be_nil
      end
    end

    context "when invalid" do
      before do
        Password.any_instance.stub(:valid?).and_return(false)
      end

      it "assigns @password and its attributes" do
        put :update, password: {old: "secret"}
        expect(assigns(:password)).not_to be_nil
        expect(assigns(:password).old).to eq "secret"
      end

      it "renders :edit" do
        put :update
        expect(response).to render_template(:edit)
      end
    end
  end
end
