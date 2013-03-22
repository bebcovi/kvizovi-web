require "spec_helper"

describe SessionsController do
  describe "#new" do
    it "assigns @login" do
      get :new, type: "school"
      expect(assigns(:login)).not_to be_nil
    end

    it "renders :new" do
      get :new, type: "school"
      expect(response).to render_template(:new)
    end
  end

  describe "#create" do
    context "on valid login" do
      before do
        Login.any_instance.stub(:valid?).and_return(true)
        Login.any_instance.stub(:user).and_return(stub(id: 1))
      end

      it "logs in the user" do
        post :create, type: "school"
        expect(cookies[:user_id]).to eq 1
      end

      it "redirects to root" do
        post :create, type: "school"
        expect(response).to redirect_to(root_path)
      end
    end

    context "on invalid login" do
      before do
        Login.any_instance.stub(:valid?).and_return(false)
      end

      it "assigns @login and its attributes" do
        post :create, type: "school", login: {username: "janko"}
        expect(assigns(:login)).not_to be_nil
        expect(assigns(:login).username).to eq "janko"
      end

      it "sets the alert message" do
        post :create, type: "school"
        expect(flash[:alert]).not_to be_nil
      end

      it "renders :new" do
        post :create, type: "school"
        expect(response).to render_template(:new)
      end
    end
  end

  describe "#destroy" do
    it "logs out the user" do
      cookies[:user_id] = 1
      delete :destroy
      expect(cookies[:user_id]).to be_nil
    end

    it "redirects to root_path" do
      delete :destroy
      expect(response).to redirect_to(root_path)
    end
  end
end
