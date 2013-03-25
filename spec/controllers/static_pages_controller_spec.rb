require "spec_helper"

describe StaticPagesController do
  render_views

  describe "#tour" do
    it "doesn't raise any errors" do
      get :tour
    end
  end

  describe "#contact" do
    it "doesn't raise any errors" do
      get :contact
    end
  end
end
