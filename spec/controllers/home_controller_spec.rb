require "spec_helper"

describe HomeController do
  describe "#index" do
    context "when user is not logged in" do
      before do
        get :index
      end

      it "renders the template" do
        expect(response).to be_a_success
      end
    end

    context "when user is logged in" do
      before do
        login_as(:school)
        get :index
      end

      it "redirects to the account" do
        expect(response).to redirect_to(account_quizzes_path)
      end
    end
  end
end
