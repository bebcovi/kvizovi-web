require "spec_helper"

describe HomeController do
  describe "#index" do
    it "doesn't raise errors" do
      get :index
    end
  end
end
