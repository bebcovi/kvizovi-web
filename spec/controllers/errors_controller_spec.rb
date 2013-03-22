require "spec_helper"

describe ErrorsController do
  describe "#show" do
    it "renders the appropriate template" do
      get :show, code: 500
      expect(response).to render_template("500")

      get :show, code: 404
      expect(response).to render_template("404")
    end

    it "returns the appropriate status" do
      get :show, code: 500
      expect(response.status).to eq 500

      get :show, code: 404
      expect(response.status).to eq 404
    end
  end
end
