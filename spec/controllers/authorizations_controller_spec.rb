require "spec_helper"

describe AuthorizationsController do
  describe "#new" do
    it "assigns @authorization" do
      get :new
      expect(assigns(:authorization)).not_to be_nil
    end

    it "renders :new" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "#create" do
    context "when valid" do
      before do
        Authorization.any_instance.stub(:valid?).and_return(true)
      end

      it "redirects to new registration" do
        post :create
        expect(response).to redirect_to(new_registration_path(type: "school"))
      end

      it "assigns the flash authorization" do
        post :create
        expect(flash[:authorized]).to eq true
      end
    end

    context "when invalid" do
      before do
        Authorization.any_instance.stub(:valid?).and_return(false)
      end

      it "assigns @authorization" do
        post :create
        expect(assigns(:authorization)).not_to be_nil
      end

      it "renders :new" do
        post :create
        expect(response).to render_template(:new)
      end
    end
  end
end
