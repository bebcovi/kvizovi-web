require "spec_helper"

feature "Students" do
  let!(:school) { register(:school) }
  let(:student) { create(:student) }

  background do
    login(school)
  end

  scenario "Viewing" do
    school.students << student

    click_on "Učenici"

    expect(page).to have_content(student.full_name)
  end
end
