require "spec_helper"

describe ProfilesController, user: :school do
  before do
    @user = Factory.create(:school)
    login_as(@user)
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
      before do
        @user.stub(:valid?) { true }
      end

      it "saves the record" do
        put :update, school: {name: "New name"}
        expect(@user.reload.name).to eq "New name"
      end
    end

    context "when invalid" do
      before do
        @user.stub(:valid?) { false }
      end

      it "doesn't raise errors" do
        put :update
      end
    end
  end
end
