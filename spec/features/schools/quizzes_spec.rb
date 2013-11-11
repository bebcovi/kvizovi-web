require "spec_helper"

feature "Quizzes" do
  let!(:school) { register(:school) }
  let(:quiz) { create(:quiz) }

  background do
    login(school)
  end

  scenario "Creating, updating and destroying", js: true do
    visit account_quizzes_path

    fill_in "Naziv", with: "Kviz"
    submit

    expect(page).to have_css(".quiz")
    expect(page).not_to have_content("Trenutno nemate kvizova")

    click_on "Izmijeni"
    submit

    expect(page).to have_css(".quiz")

    click_on "Izbriši"

    expect(page).not_to have_css(".quiz")
  end

  scenario "Activating", js: true do
    school.quizzes << quiz

    visit account_quizzes_path

    find(".toggle-activation").click
    expect(page).to have_css(".icon-lamp")
    find(".toggle-activation").click
    expect(page).to have_css(".icon-lamp-full")

    visit account_quiz_questions_path(quiz)

    find(".toggle-activation").click
    expect(page).to have_css(".icon-lamp")
    find(".toggle-activation").click
    expect(page).to have_css(".icon-lamp-full")
  end
end
