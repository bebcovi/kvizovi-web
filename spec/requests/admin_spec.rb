require "spec_helper_full"

describe "Admin page" do
  before(:all) {
    @school = create(:school)
    @janko, @matija = create(:janko, school: @school), create(:matija, school: @school)
    @quiz = create(:quiz, school: @school)
  }

  it "doesn't raise any errors" do
    visit admin_path
    click_on @school.name
  end

  after(:all) { @school.destroy }
end
