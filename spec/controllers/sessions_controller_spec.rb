require "spec_helper"

describe SessionsController do
  before do
    @school = create(:school)
    @parameters = {}
  end

  describe "#new" do
    before do
      @parameters.update(type: "school")
    end

    it "renders :new" do
      get :new, @parameters
      expect(response).to render_template(:new)
    end
  end

  describe "#create" do
    before do
      @parameters.update(type: "school")
    end

    context "on valid login" do
      before do
        @parameters.update(login: {username: @school.username, password: @school.password})
      end

      it "logs in the user" do
        post :create, @parameters
        expect(cookies[:user_id]).not_to be_nil
      end

      it "redirects to root" do
        post :create, @parameters
        expect(response).to redirect_to(root_path)
      end
    end

    context "on invalid login" do
      before do
        @parameters.update(login: {username: @school.username, password: nil})
      end

      it "assigns @login and its attributes" do
        post :create, @parameters
        expect(assigns(:login)).not_to be_nil
        expect(assigns(:login).username).to eq @parameters[:login][:username]
      end

      it "sets the alert message" do
        post :create, @parameters
        expect(flash).to have_alert_message
      end

      it "renders :new" do
        post :create, @parameters
        expect(response).to render_template(:new)
      end
    end
  end

  describe "#destroy" do
    it "logs out the user" do
      cookies[:user_id] = 1
      delete :destroy, @parameters
      expect(cookies[:user_id]).to be_nil
    end

    it "redirects to root_path" do
      delete :destroy, @parameters
      expect(response).to redirect_to root_path
    end
  end
end
