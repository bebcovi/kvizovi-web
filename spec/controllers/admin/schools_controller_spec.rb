require "spec_helper"

describe Admin::SchoolsController do
  describe "#index" do
    it "doesn't raise errors" do
      get :index
    end
  end

  describe "#show" do
    before do
      @school = FactoryGirl.create(:school)
    end

    it "doesn't raise errors" do
      get :show, id: @school.id
    end
  end
end
