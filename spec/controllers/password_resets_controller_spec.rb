require "spec_helper"
require "nokogiri"

describe PasswordResetsController, user: :school do
  before do
    @user = FactoryGirl.create(:school, email: "jon.snow@example.com")
  end

  describe "#new" do
    it "doesn't raise errors" do
      get :new
    end
  end

  describe "#confirm" do
    context "when valid" do
      it "assigns the confirmation ID to the user" do
        PasswordResetService.any_instance.should_receive(:generate_confirmation_id)
        post :confirm, email: @user.email
      end

      it "sends the confirmation email" do
        post :confirm, email: @user.email
        expect(ActionMailer::Base.deliveries).to have(1).item
        expect(ActionMailer::Base.deliveries.first.to).to eq [@user.email]
      end

      it "assigns a flash message" do
        post :confirm, email: @user.email
        expect(flash[:notice]).to be_present
      end
    end

    context "when invalid" do
      it "doesn't raise errors" do
        post :confirm
      end
    end
  end

  describe "#create" do
    it "compares the confirmation ID" do
      PasswordResetService.any_instance.should_not_receive(:reset_password)
      post :create, email: @user.email, confirmation_id: "foo"
    end

    context "when valid" do
      before do
        @user.update_attributes(password_reset_confirmation_id: "foo")
      end

      it "resets the password" do
        PasswordResetService.any_instance.should_receive(:reset_password)
        post :create, email: @user.email, confirmation_id: "foo"
      end

      it "emails the resetted password" do
        post :create, email: @user.email, confirmation_id: "foo"
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
