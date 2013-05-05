require "spec_helper"

describe StudentsController, user: :school do
  before do
    @school = Factory.create(:school)
    login_as(@school)
  end

  describe "#index" do
    it "assigns students" do
      students = Factory.create_list(:student, 2, school: @school)
      get :index
      expect(assigns(:students)).to eq students
    end
  end
end
