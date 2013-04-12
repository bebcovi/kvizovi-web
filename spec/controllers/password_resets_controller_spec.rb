require "spec_helper"
require "nokogiri"

describe PasswordResetsController do
  school!

  before do
    @user = Factory.create_without_validation(:empty_school, email: "jon.snow@example.com")
  end

  describe "#new" do
    it "doesn't raise errors" do
      get :new
    end
  end

  describe "#create" do
    context "when valid" do
      before do
        @user.class.any_instance.stub(:valid?) { true }
        PasswordResetter.any_instance.stub(:reset_password)
      end

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
