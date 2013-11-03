require "spec_helper"

describe Admin::SchoolsController do
  describe "#index" do
    before do
      get :index
    end

    it "renders the template" do
      expect(response).to be_a_success
    end
  end

  describe "#show" do
    before do
      @school = create(:school)
      get :show, id: @school.id
    end

    it "renders the template" do
      expect(response).to be_a_success
    end
  end
end
