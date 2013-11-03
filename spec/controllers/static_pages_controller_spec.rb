require "spec_helper"

describe StaticPagesController do
  render_views

  describe "#tour" do
    before do
      get :tour
    end

    it "renders the template" do
      expect(response).to be_a_success
    end
  end

  describe "#contact" do
    before do
      get :contact
    end

    it "renders the template" do
      expect(response).to be_a_success
    end
  end
end
