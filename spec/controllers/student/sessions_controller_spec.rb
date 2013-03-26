require "spec_helper"

describe Student::SessionsController do
  describe "#new" do
    it "assigns @login" do
      get :new
      expect(assigns(:login)).to be_a(Login)
    end

    it "renders :new" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "#create" do
    context "on valid login" do
      before do
        Login.any_instance.stub(:valid?).and_return(true)
        controller.stub(:log_in!)
      end

      it "logs in the user" do
        controller.should_receive(:log_in!)
        post :create
      end

      it "redirects to root" do
        post :create
        expect(response).to redirect_to(root_path)
      end
    end

    context "on invalid login" do
      before do
        Login.any_instance.stub(:valid?).and_return(false)
      end

      it "assigns @login and its attributes" do
        post :create, login: {username: "janko"}
        expect(assigns(:login)).not_to be_nil
        expect(assigns(:login).username).to eq "janko"
      end

      it "sets the alert message" do
        post :create
        expect(flash[:alert]).not_to be_nil
      end

      it "renders :new" do
        post :create
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
