require "spec_helper"

describe EmailsController, user: :student do
  before do
    @user = FactoryGirl.create(:student)
    login_as(@user)
  end

  describe "#new" do
    it "doesn't raise errors" do
      get :new
    end
  end

  describe "#create" do
    context "when valid" do
      before { valid!(@user.class) }

      it "assigns the email to the user" do
        post :create, @user.type => {email: "jon.snow@example.com"}
        expect(@user.reload.email).to eq "jon.snow@example.com"
      end
    end

    context "when not valid" do
      before { invalid!(@user.class) }

      it "doesn't raise errors" do
        post :create, @user.type => {email: nil}
      end
    end
  end
end
