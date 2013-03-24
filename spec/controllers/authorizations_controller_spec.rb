require "spec_helper"

describe AuthorizationsController do
  describe "#new" do
    it "assigns new authorization" do
      get :new, type: "school"
      expect(assigns(:authorization)).to be_a(Authorization)
    end

    it "renders :new" do
      get :new, type: "school"
      expect(response).to render_template(:new)
    end
  end

  describe "#create" do
    context "when valid" do
      before do
        Authorization.any_instance.stub(:valid?).and_return(true)
      end

      it "assigns the flash authorization" do
        post :create, type: "school"
        expect(flash[:authorized]).to eq true
      end

      it "redirects to new registration" do
        post :create, type: "school"
        expect(response).to redirect_to(new_registration_path(type: "school"))
      end
    end

    context "when invalid" do
      before do
        Authorization.any_instance.stub(:valid?).and_return(false)
      end

      it "assigns authorization" do
        post :create, type: "school"
        expect(assigns(:authorization)).to be_a(Authorization)
      end

      it "renders :new" do
        post :create, type: "school"
        expect(response).to render_template(:new)
      end
    end
  end
end
