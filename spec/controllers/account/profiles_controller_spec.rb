require "spec_helper"

describe Account::ProfilesController, user: :school do
  before do
    @user = FactoryGirl.create(:school)
    sign_in(@user)
  end

  describe "#show" do
    it "doesn't raise errors" do
      get :show
    end
  end

  describe "#edit" do
    it "doesn't raise errors" do
      get :edit
    end
  end

  describe "#update" do
    context "when valid" do
      before { valid!(@user.class) }

      it "saves the record" do
        put :update, @user.type => {name: "New name"}
        expect(@user.reload.name).to eq "New name"
      end
    end

    context "when invalid" do
      before { invalid!(@user.class) }

      it "doesn't raise errors" do
        put :update, @user.type => {name: nil}
      end
    end
  end
end
