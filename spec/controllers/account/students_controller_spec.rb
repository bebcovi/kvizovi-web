require "spec_helper"

describe Account::StudentsController, user: :school do
  before do
    @school = FactoryGirl.create(:school)
    sign_in(@school)
  end

  describe "#index" do
    it "assigns students" do
      students = FactoryGirl.create_list(:student, 2, school: @school)
      get :index
      expect(assigns(:students)).to eq students
    end
  end
end
