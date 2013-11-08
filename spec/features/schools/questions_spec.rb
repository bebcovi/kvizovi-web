require "spec_helper"

feature "Questions" do
  let!(:school) { register(:school) }
  let(:quiz) { create(:quiz) }

  background do
    login(school)
    school.quizzes << quiz
  end

  scenario "Managing boolean questions", js: true do
    visit account_quiz_questions_path(quiz)
    click_on "Novo pitanje"
    click_on "Točno/netočno"
    attach_file "Slika", photo_path
    fill_in "Tekst pitanja", with: "Stannis Baratheon won the war against King's Landing."
    choose "Netočno"
    submit

    expect(page).to have_css(".boolean_question")

    click_on "Izmijeni"
    submit

    expect(page).to have_css(".boolean_question")

    click_on "Izbriši"

    expect(page).to have_no_css(".boolean_question")
  end

  scenario "Managing choice questions", js: true do
    visit account_quiz_questions_path(quiz)
    click_on "Novo pitanje"
    click_on "Ponuđeni odgovori"

    attach_file "Slika", photo_path
    fill_in "Tekst pitanja", with: "Eliminate the bastard."
    fill_in "Ponuđeni odgovor 1", with: "Jon Snow"
    fill_in "Ponuđeni odgovor 2", with: "Robb Stark"
    fill_in "Ponuđeni odgovor 3", with: "Bran Stark"
    all(".choice-option").last.find(".close").click
    submit

    expect(page).to have_css(".choice_question")

    click_on "Izmijeni"
    click_on "Dodaj ponuđeni odgovor"
    fill_in "Ponuđeni odgovor 4", with: "Ned Stark"
    submit

    expect(page).to have_css(".choice_question")

    click_on "Izbriši"

    expect(page).to have_no_css(".choice_question")
  end

  scenario "Managing association questions", js: true do
    visit account_quiz_questions_path(quiz)
    click_on "Novo pitanje"
    click_on "Asocijacija"

    attach_file "Slika", photo_path
    fill_in "Tekst pitanja", with: "Connect Game of Thrones characters with their phrases."
    fill_in "Asocijacija 1a", with: "Sansa Stark";      fill_in "Asocijacija 1b", with: %("...but I don't want anyone smart, brave or good looking, I want Joffrey!")
    fill_in "Asocijacija 2a", with: "Tywin Lannister";  fill_in "Asocijacija 2b", with: %("Attacking Ned Stark in the middle of King Landing was stupid. Lannisters don't do stupid things.")
    fill_in "Asocijacija 3a", with: "Tyrion Lannister"; fill_in "Asocijacija 3b", with: %("Why is every god so vicious? Why aren't there gods of tits and wine?")
    all(".association-option").last.find(".close").click
    submit

    expect(page).to have_css(".association_question")

    click_on "Izmijeni"
    click_on "Dodaj asocijaciju"
    fill_in "Asocijacija 4a", with: "Cercei Lannister"; fill_in "Asocijacija 4b", with: %("Everyone except us is our enemy.")
    submit

    expect(page).to have_css(".association_question")

    click_on "Izbriši"

    expect(page).to have_no_css(".association_question")
  end

  scenario "Managing text questions", js: true do
    visit account_quiz_questions_path(quiz)
    click_on "Novo pitanje"
    click_on "Upiši točan odgovor"

    find(".toggle-type").click
    fill_in "URL od slike", with: "http://3.bp.blogspot.com/-bnKL0iosAc8/UOmO_a_ujuI/AAAAAAAAmVI/R5aNBx_yx2w/s1600/flbp-girls-women-sexy-9.jpg"
    fill_in "Tekst pitanja", with: "Which family does Khaleesi belong to?"
    fill_in "Odgovor", with: "Targaryen"
    submit

    expect(page).to have_css(".text_question")

    click_on "Izmijeni"
    submit

    expect(page).to have_css(".text_question")

    click_on "Izbriši"

    expect(page).to have_no_css(".text_question")
  end

  scenario "Changing the order", js: true do
    quiz.questions = [
      create(:boolean_question, content: "Question 1"),
      create(:boolean_question, content: "Question 2"),
      create(:boolean_question, content: "Question 3"),
    ]

    visit account_quiz_questions_path(quiz)
    click_on "Izmijeni redoslijed"

    fill_in "quiz_questions_attributes_0_position", with: "1", visible: false
    fill_in "quiz_questions_attributes_1_position", with: "3", visible: false
    fill_in "quiz_questions_attributes_2_position", with: "2", visible: false
    submit

    expect(all(".boolean_question")[0]).to have_content("Question 1")
    expect(all(".boolean_question")[1]).to have_content("Question 3")
    expect(all(".boolean_question")[2]).to have_content("Question 2")
  end
end
