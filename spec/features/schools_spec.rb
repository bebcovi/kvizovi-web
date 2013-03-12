require "spec_helper"

feature "Schools" do
  scenario "visiting home" do
    school = create(:school)
    login_as(school)
    visit root_path

    expect(current_path).to eq quizzes_path
  end
end
