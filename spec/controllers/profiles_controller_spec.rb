require "spec_helper"

describe ProfilesController do
  school!

  before do
    @user = Factory.create_without_validation(:empty_school)
    controller.send(:log_in!, @user)
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
        @user.class.any_instance.stub(:valid?) { true }
      end

      it "saves the record" do
        expect {
          put :update, school: {name: "New name"}
        }.to change { @user.reload.name }.to "New name"
      end
    end

    context "when invalid" do
      before do
        @user.class.any_instance.stub(:valid?) { false }
      end

      it "doesn't raise errors" do
        put :update
      end
    end
  end
end
