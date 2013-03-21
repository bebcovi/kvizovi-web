require "spec_helper"

describe AuthorizationsController do
  before do
    @parameters = {}
  end

  describe "#new" do
    it "renders :new" do
      get :new, @parameters
      expect(response).to render_template(:new)
    end
  end

  describe "#create" do
    context "when valid" do
      before do
        @parameters.update(authorization: {secret_key: ENV["SECRET_KEY"]})
      end

      it "assigns the flash authorization" do
        post :create, @parameters
        expect(flash[:authorized]).to eq true
      end

      it "redirects to new registration" do
        post :create, @parameters
        expect(response).to redirect_to(new_registration_path(type: "school"))
      end
    end

    context "when invalid" do
      before do
        @parameters.update(authorization: {secret_key: nil})
      end

      it "renders :new" do
        post :create, @parameters
        expect(response).to render_template(:new)
      end
    end
  end
end
