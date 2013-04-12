require "spec_helper"

describe AuthorizationsController do
  school!

  describe "#new" do
    it "doesn't raise errors" do
      get :new
    end
  end

  describe "#create" do
    context "when valid" do
      it "assigns flash authorized" do
        post :create, secret_key: ENV["SECRET_KEY"]
        expect(flash[:authorized]).not_to be_nil
      end
    end

    context "when invalid" do
      it "doesn't raise errors" do
        post :create
      end
    end
  end
end
