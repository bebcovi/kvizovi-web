require "spec_helper"

describe HomeController do
  describe "#index" do
    context "when user is not logged in" do
      it "renders the template" do
        get :index
      end
    end

    context "when user is logged in" do
      it "redirects if user is logged in" do
        controller.send(:log_in!, Factory.create_without_validation(:empty_school))
        get :index
        expect(response).to be_a_redirect
      end
    end
  end
end
