require "spec_helper"

describe School::PasswordResetsController do
  before(:all) { @school = create(:school) }

  describe "#new" do
    it "renders :new" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "#create" do
    context "when valid" do
      before do
        @school.class.any_instance.stub(:update_attributes)
      end

      it "resets the password" do
        @school.class.any_instance.unstub(:update_attributes)
        expect {
          post :create, email: @school.email
        }.to change{@school.reload.password_digest}
      end

      it "sends the email with the new password" do
        post :create, email: @school.email
        expect(ActionMailer::Base.deliveries).to have(1).item
        expect(ActionMailer::Base.deliveries.first.to).to eq [@school.email]
      end

      it "redirects to login page" do
        post :create, email: @school.email
        expect(response).to redirect_to(login_path)
      end

      it "sets a flash message" do
        post :create, email: @school.email
        expect(flash[:notice]).not_to be_nil
      end
    end

    context "when invalid" do
      it "sets the alert message" do
        post :create
        expect(flash[:alert]).not_to be_nil
      end

      it "renders :new" do
        post :create
        expect(response).to render_template(:new)
      end
    end
  end

  after(:all) { @school.destroy }
end
