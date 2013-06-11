require "spec_helper"

describe StudentsController, user: :school do
  before do
    @school = FactoryGirl.create(:school)
    login_as(@school)
  end

  describe "#index" do
    it "assigns students" do
      students = FactoryGirl.create_list(:student, 2, school: @school)
      get :index
      expect(assigns(:students)).to eq students
    end
  end
end
