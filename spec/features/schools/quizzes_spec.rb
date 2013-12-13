require "spec_helper"

feature "Quizzes" do
  let!(:school) { register(:school) }
  let(:quiz) { create(:quiz) }

  background do
    login(school)
  end

  scenario "Creating, updating and destroying", js: true do
    visit account_quizzes_path

    click_on "Novi kviz"
    fill_in "Naziv", with: "Novi kviz"
    attach_file "Slika", photo_path
    submit

    expect(current_path).to eq account_quiz_questions_path(Quiz.last)
    expect(page).to have_content("Novi kviz")

    click_on "Izmijeni"
    fill_in "Naziv", with: "Izmijenjeni kviz"
    submit

    expect(current_path).to eq account_quiz_questions_path(Quiz.last)
    expect(page).to have_content("Izmijenjeni kviz")

    click_on "Izbriši"
    click_on "Jesam"

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
