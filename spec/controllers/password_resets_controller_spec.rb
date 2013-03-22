require "spec_helper"

describe PasswordResetsController do
  describe "#new" do
    it "renders :new" do
      get :new, type: "school"
      expect(response).to render_template(:new)
    end
  end

  describe "#create" do
    context "when valid" do
      before do
        @user = stub(email: "janko@example.com", type: "school").as_null_object
        School.stub(:find_by_email).and_return(@user)
      end

      it "resets the password" do
        PasswordResetter.any_instance.should_receive(:reset_password)
        post :create, type: "school"
      end

      it "sends the email with the new password" do
        post :create, type: "school"
        expect(ActionMailer::Base.deliveries).to have(1).item
        expect(ActionMailer::Base.deliveries.first.to).to eq ["janko@example.com"]
      end

      it "redirects to login page" do
        post :create, type: "school"
        expect(response).to redirect_to(login_path(type: "school"))
      end

      it "sets a flash message" do
        post :create, type: "school"
        expect(flash[:notice]).not_to be_nil
      end
    end

    context "when invalid" do
      before do
        School.stub(:find_by_email).and_return(nil)
      end

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
end
