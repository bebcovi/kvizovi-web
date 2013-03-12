require "spec_helper"

feature "Students" do
  scenario "visiting home" do
    student = create(:student, :with_school)
    login_as(student)
    visit root_path

    expect(current_path).to eq new_game_path
  end
end
