require "spec_helper"

feature "Screenshots", driver: :selenium do
  before do
    Capybara.app_host = "http://kvizovi.org"
    page.driver.browser.manage.window.resize_to 900, 900
  end

  def save_screenshot(basename)
    super "doc/images/#{basename}.png"
  end

  scenario "General" do
    visit root_path
    save_screenshot("home")

    visit new_school_session_path
    fill_in "Korisničko ime", with: "admin"
    fill_in "Lozinka",        with: "admin"
    submit

    click_on "Anketa"
    page.has_css?("h1", text: "Anketa")
    save_screenshot("survey")
  end

  scenario "School" do
    visit new_school_session_path
    save_screenshot("school/login")

    fill_in "Korisničko ime", with: "admin"
    fill_in "Lozinka",        with: "admin"
    submit

    find(".breadcrumb").has_text?("Kvizovi")
    save_screenshot("school/quizzes")

    within(find(".quiz", text: "Igra prijestolja")) { click_on "Pitanja" }
    find(".breadcrumb").has_text?("Igra prijestolja")
    save_screenshot("school/quiz")

    click_on "Učenici"
    page.has_no_css?(".breadcrumb")
    save_screenshot("school/students")

    click_on "Odigrani kvizovi"
    find(".breadcrumb").has_text?("Odigrani kvizovi")
    save_screenshot("school/played_quizzes")

    within(first(".played_quiz", text: "Igra prijestolja")) { click_on "Igra prijestolja" }
    find(".breadcrumb").has_text?("Igra prijestolja")
    save_screenshot("school/played_quiz")
  end

  scenario "Student" do
    visit new_student_session_path
    save_screenshot("student/login")

    fill_in "Korisničko ime", with: "matija"
    fill_in "Lozinka",        with: "matija"
    submit

    choose "Igra prijestolja"
    choose "Samo ja"
    save_screenshot("student/quizzes")

    click_on "Započni kviz"

    questions = []

    while questions.count < 4
      case
      when page.has_text?("Stannis je pobijedio bitku kod Blackwater Baya.")

        save_screenshot("student/boolean_question")
        questions << :boolean
        choose "Netočno"
        click_on "Odgovori"
        page.has_css?(".modal")
        save_screenshot("student/boolean_question_correct")
        click_on "Sljedeće pitanje"

      when page.has_text?("Koji od sljedećih likova nije Lannister?")

        save_screenshot("student/choice_question")
        questions << :choice
        choose "Sansa"
        click_on "Odgovori"
        page.has_css?(".modal")
        save_screenshot("student/choice_question_correct")
        click_on "Sljedeće pitanje"

      when page.has_text?("Pridruži ljikove njihovim kućama")

        save_screenshot("student/association_question")
        questions << :association
        click_on "Odgovori"
        page.has_css?(".modal")
        save_screenshot("student/association_question_incorrect")
        click_on "Sljedeće pitanje"

      when page.has_text?("Kako glasi izreka kuće Stark?")

        save_screenshot("student/text_question")
        questions << :text
        fill_in "Odgovor", with: "Winter is coming."
        click_on "Odgovori"
        page.has_css?(".modal")
        save_screenshot("student/text_question_correct")
        click_on "Sljedeće pitanje"

      else

        click_on "Odgovori"
        click_on "Sljedeće pitanje"

      end

      page.has_no_css?(".modal")
    end

    click_on "Prekini"
    click_on "Jesam"
  end
end
