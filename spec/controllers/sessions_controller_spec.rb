require "spec_helper"

describe SessionsController do
  before { request.host = "school.example.com" }

  describe "#new" do
    it "doesn't raise errors" do
      get :new
    end
  end

  describe "#create" do
    context "when valid" do
      before do
        Login.any_instance.stub(:valid?) { true }
        @user = Factory.create_without_validation(:empty_school)
        Login.any_instance.stub(:user) { @user }
      end

      it "logs in the user" do
        post :create
        expect(cookies[:user_id]).to be_present
      end
    end

    context "when invalid" do
      before do
        Login.any_instance.stub(:valid?) { false }
      end

      it "doesn't raise errors" do
        post :create
      end
    end
  end

  describe "#destroy" do
    before do
      @user = Factory.create_without_validation(:empty_school)
      controller.send(:log_in!, @user)
    end

    it "logs the user out" do
      delete :destroy
      expect(cookies[:user_id]).to be_blank
    end
  end
end
