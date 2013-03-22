require "spec_helper"

describe ProfilesController do
  before do
    @user = School.new
    controller.stub(:current_user).and_return(@user)
  end

  describe "#show" do
    it "assigns @user" do
      get :show
      expect(assigns(:user)).not_to be_nil
    end

    it "renders :show" do
      get :show
      expect(response).to render_template(:show)
    end
  end

  describe "#edit" do
    it "assigns @user" do
      get :edit
      expect(assigns(:user)).not_to be_nil
    end

    it "renders :edit" do
      get :edit
      expect(response).to render_template(:edit)
    end
  end

  describe "#update" do
    context "when valid" do
      before do
        @user.stub(:valid?).and_return(true)
        @user.stub(:save)
      end

      it "updates user's attributes" do
        @user.should_receive(:save)
        post :update, school: {name: "Name"}
        expect(assigns(:user).name).to eq "Name"
      end

      it "redirects to profile" do
        post :update
        expect(response).to redirect_to(profile_path)
      end
    end

    context "when invalid" do
      before do
        @user.stub(:valid?).and_return(false)
      end

      it "assigns @user and its attributes" do
        post :update, school: {name: "Name"}
        expect(assigns(:user)).not_to be_nil
        expect(assigns(:user).name).to eq "Name"
      end

      it "renders :edit" do
        post :update
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "#delete" do
    it "renders :delete" do
      get :delete
      expect(response).to render_template(:delete)
    end
  end

  describe "#destroy" do
    context "when valid" do
      before do
        @user.stub(:authenticate).and_return(true)
      end

      it "deletes the user" do
        @user.should_receive(:destroy)
        delete :destroy
      end

      it "logs the user out" do
        cookies[:user_id] = 1
        delete :destroy
        expect(cookies[:user_id]).to be_nil
      end

      it "redirects to root" do
        delete :destroy
        expect(response).to redirect_to(root_path)
      end

      it "sets a flash notice" do
        delete :destroy
        expect(flash[:notice]).not_to be_nil
      end
    end

    context "when not valid" do
      before do
        @user.stub(:authenticate).and_return(false)
      end

      it "sets an alert message" do
        delete :destroy
        expect(flash[:alert]).not_to be_nil
      end

      it "renders :delete" do
        delete :destroy
        expect(response).to render_template(:delete)
      end
    end
  end
end
