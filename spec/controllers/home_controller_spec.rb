require "spec_helper"

describe HomeController do
  describe "#index" do
    context "when user is not logged in" do
      it "renders the template" do
        get :index
      end
    end

    context "when user is logged in" do
      before do
        user = Factory.create(:user)
        login_as(user)
      end

      it "redirects" do
        get :index
        expect(response).to be_a_redirect
      end
    end
  end
end
