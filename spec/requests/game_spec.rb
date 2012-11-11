# encoding: utf-8
require "spec_helper_full"

describe "Game" do
  before(:all) do
    @school = create(:school)
    @quiz = create(:quiz, school: @school)
    @janko = create(:janko, school: @school, grade: "#{@quiz.grades.first}a")
    @matija = create(:matija, school: @school, grade: "#{@quiz.grades.first}d")
    @boolean_question     = create(:boolean_question, quizzes: [@quiz])
    @choice_question      = create(:choice_question, quizzes: [@quiz])
    @association_question = create(:association_question, quizzes: [@quiz])
    @image_question       = create(:image_question, quizzes: [@quiz])
    @text_question        = create(:text_question, quizzes: [@quiz])
  end

  before(:each) do
    login(:student, attributes_for(:janko))
  end

  describe "create" do
    it "keeps the fields filled in on validation errors" do
      visit new_game_path

      choose @quiz.name
      choose "Još netko"
      fill_in "Korisničko ime", with: @matija.username
      click_on "Započni kviz"

      find_field(@quiz.name).should be_checked
      find_field("Još netko").should be_checked
      find_field("Korisničko ime").value.should_not be_nil
    end

    context "with 1 player" do
      def fill_in_the_form
        choose @quiz.name
        choose "Samo ja"
      end

      it "works" do
        visit new_game_path

        fill_in_the_form
        click_on "Započni kviz"

        current_path.should eq edit_game_path
      end
    end

    context "with 2 players" do
      def fill_in_the_form
        choose @quiz.name
        choose "Još netko"
        fill_in "Korisničko ime", with: attributes_for(:matija)[:username]
        fill_in "Lozinka", with: attributes_for(:matija)[:password]
      end

      it "doesn't let the same student to be authenticated again" do
        visit new_game_path

        choose @quiz.name
        choose "Još netko"
        fill_in "Korisničko ime", with: attributes_for(:janko)[:username]
        fill_in "Lozinka", with: attributes_for(:janko)[:password]
        click_on "Započni kviz"

        current_path.should_not eq edit_game_path
      end

      it "works" do
        visit new_game_path

        fill_in_the_form
        click_on "Započni kviz"

        current_path.should eq edit_game_path
      end
    end
  end

  describe "playing" do
    def start_game
      visit new_game_path
      choose @quiz.name
      choose "Samo ja"
      click_on "Započni kviz"
    end

    it "doesn't raise errors when questions are not answered" do
      start_game

      while current_path == edit_game_path
        click_on "Odgovori"
        within(".form_controls") { find("*").click }
      end

      first(".bar").text.strip.should eq "0%"
    end

    it "displays after each answer whether that answer was correct" do
      start_game

      category = first("form")[:class].split(" ").last.split("_").last
      answer_question(category)
      click_on "Odgovori"

      page.should have_css("h1.correct")

      click_on "Sljedeće pitanje"
      click_on "Odgovori"

      page.should have_css("h1.wrong")
    end

    describe "giving up" do
      it "has a link" do
        start_game
        click_on "Prekini"
        current_path.should eq delete_game_path
      end

      it "can be canceled" do
        start_game
        click_on "Prekini"
        click_on "Nisam"
        current_path.should eq edit_game_path
      end

      it "can be confirmed" do
        start_game
        click_on "Prekini"
        click_on "Jesam"
        current_path.should eq new_game_path
      end
    end

    it "redirects back when it wants to play again after interrupt" do
      start_game
      click_on "Prekini"
      click_on "Jesam"
      visit edit_game_path
      current_path.should eq new_game_path
    end

    def answer_question(category)
      case category
      when "boolean"
        choose(@boolean_question.answer ? "Točno" : "Netočno")
      when "choice"
        choose @choice_question.answer
      when "association"
        (1..@association_question.associations.count).each do |n|
          fill_in "game_answer_#{n * 2 - 1}", with: @association_question.associations.left_side[n - 1]
          fill_in "game_answer_#{n * 2}", with: @association_question.associations.right_side[n - 1]
        end
      when "image"
        fill_in "Odgovor", with: @image_question.answer
      when "text"
        fill_in "Odgovor", with: @text_question.answer
      end
    end

    context "with 1 player" do
      def start_game
        visit new_game_path
        choose @quiz.name
        choose "Samo ja"
        click_on "Započni kviz"
      end

      it "correctly sums up the score" do
        start_game

        while current_path == edit_game_path
          category = first("form")[:class].split(" ").last.split("_").last
          answer_question(category)
          click_on "Odgovori"
          within(".form_controls") { find("*").click }
        end

        first(".bar").text.strip.should eq "100%"
      end
    end

    context "with 2 players" do
      def start_game
        visit new_game_path
        choose @quiz.name
        choose "Još netko"
        fill_in "Korisničko ime", with: attributes_for(:matija)[:username]
        fill_in "Lozinka", with: attributes_for(:matija)[:password]
        click_on "Započni kviz"
      end

      it "correctly sums up the score" do
        start_game

        while current_path == edit_game_path
          category = first("form")[:class].split(" ").last.split("_").last
          answer_question(category)
          click_on "Odgovori"
          within(".form_controls") { find("*").click }
        end

        all(".bar").map(&:text).map(&:strip).each { |str| str.should_not eq "0%" }
      end
    end
  end

  after(:all) { @school.destroy }
end
