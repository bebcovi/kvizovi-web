require "spec_helper"

feature "Quizzes" do
  before do
    @school = create(:school)
    login_as(@school)
  end

  scenario "A school can create, update and delete quizzes" do
    click_on "Novi kviz"

    fill_in "Naziv", with: "Neki naziv"
    click_on "Spremi"

    expect(page).to have_content("Neki naziv")

    quiz = @school.quizzes.find_by_name("Neki naziv")
    within(quiz) { click_on "Izmijeni" }
    click_on "Spremi"

    within(quiz) { click_on "Izbriši" }
    click_on "Jesam"

    expect(page).not_to have_content("Neki kviz")
  end
end
