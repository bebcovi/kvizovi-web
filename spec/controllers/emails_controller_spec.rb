require "spec_helper"

describe EmailsController, user: :student do
  before do
    @user = Factory.create(:student)
    login_as(@user)
  end

  describe "#new" do
    it "doesn't raise errors" do
      get :new
    end
  end

  describe "#create" do
    context "when valid" do
      it "assigns the email to the user" do
        expect do
          post :create, @user.type => {email: "jon.snow@example.com"}
        end.to change { @user.reload.email }.to("jon.snow@example.com")
      end
    end

    context "when not valid" do
      it "doesn't raise errors" do
        post :create, @user.type => {email: nil}
      end
    end
  end
end
