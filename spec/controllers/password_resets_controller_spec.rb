require "spec_helper"

describe PasswordResetsController do
  before(:all) { @user = create(:school) }

  describe "#new" do
    it "renders :new" do
      get :new, type: "school"
      expect(response).to render_template(:new)
    end
  end

  describe "#create" do
    context "when valid" do
      before do
        @user.class.any_instance.stub(:update_attributes)
      end

      it "resets the password" do
        @user.class.any_instance.unstub(:update_attributes)
        expect {
          post :create, type: "school", email: @user.email
        }.to change{@user.reload.password_digest}
      end

      it "sends the email with the new password" do
        post :create, type: "school", email: @user.email
        expect(ActionMailer::Base.deliveries).to have(1).item
        expect(ActionMailer::Base.deliveries.first.to).to eq [@user.email]
      end

      it "redirects to login page" do
        post :create, type: "school", email: @user.email
        expect(response).to redirect_to(login_path(type: "school"))
      end

      it "sets a flash message" do
        post :create, type: "school", email: @user.email
        expect(flash[:notice]).not_to be_nil
      end
    end

    context "when invalid" do
      it "sets the alert message" do
        post :create, type: "school"
        expect(flash[:alert]).not_to be_nil
      end

      it "renders :new" do
        post :create, type: "school"
        expect(response).to render_template(:new)
      end
    end
  end

  after(:all) { @user.destroy }
end
