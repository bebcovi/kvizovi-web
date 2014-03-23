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

  describe "#contact" do
    let(:args) { [{contact: {sender: "foo@bar.com", message: "A message"}, format: "js"}] }

    it "creates an email with the contact params" do
      expect(ContactMailer).to receive(:contact).with(
        sender: "foo@bar.com",
        message: "A message",
      ).and_call_original

      post :contact, *args
    end

    it "delivers the email" do
      post :contact, *args
      expect(sent_emails).to have(1).item
    end

    it "defaults the sender email to current user's email" do
      allow(controller).to receive(:current_user) { double(email: "foo@bar.com") }
      args[0].delete(:sender)

      expect(ContactMailer).to receive(:contact).with(
        sender: "foo@bar.com",
        message: "A message",
      ).and_call_original

      post :contact, *args
    end
  end
end
