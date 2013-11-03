require "spec_helper"

feature "Quizzes" do
  let!(:school) { register(:school) }
  let(:quiz) { create(:quiz) }

  background do
    login(school)
  end

  scenario "Creating, updating and destroying" do
    visit account_quizzes_path
    click_on "Novi kviz"

    fill_in "Naziv", with: "Kviz"
    submit

    expect(page).to have_content("Kviz")

    click_on "Izmijeni"

    fill_in "Naziv", with: "Drugi kviz"
    submit

    expect(page).to have_content("Drugi kviz")

    click_on "Izbriši"

    expect(page).to have_no_content("Drugi kviz")
  end

  scenario "Activating" do
    school.quizzes << quiz

    visit account_quizzes_path

    expect { find(".toggle-activation").click }.to change{quiz.reload.activated?}
    expect { find(".toggle-activation").click }.to change{quiz.reload.activated?}
  end
end
