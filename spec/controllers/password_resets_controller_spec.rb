require "spec_helper"
require "nokogiri"

describe PasswordResetsController, user: :school do
  before do
    @user = Factory.create(:school, email: "jon.snow@example.com")
  end

  describe "#new" do
    it "doesn't raise errors" do
      get :new
    end
  end

  describe "#create" do
    context "when valid" do
      it "resets the password" do
        PasswordResetter.any_instance.should_receive(:reset_password)
        post :create, email: @user.email
      end

      it "emails the resetted password" do
        post :create, email: @user.email
        expect(ActionMailer::Base.deliveries).to have(1).item
        expect(ActionMailer::Base.deliveries.first.to).to eq [@user.email]
      end
    end

    context "when not valid" do
      it "doesn't raise errors" do
        post :create
      end
    end
  end
end
