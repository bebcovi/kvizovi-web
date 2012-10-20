# encoding: utf-8
require "spec_helper_full"

describe "Game" do
  before(:all) do
    @school = create(:school)
    @janko = create(:janko, school: @school)
    @matija = create(:matija, school: @school)
    @quiz = create(:quiz, school: @school)
    @boolean_question     = create_list(:boolean_question, 2, quiz: @quiz).first
    @choice_question      = create_list(:choice_question, 2, quiz: @quiz).first
    @association_question = create_list(:association_question, 2, quiz: @quiz).first
    @image_question       = create_list(:image_question, 2, quiz: @quiz).first
    @text_question        = create_list(:text_question, 2, quiz: @quiz).first
    @quiz.update_attributes!(activated: true)
  end

  before(:each) do
    login(:student, attributes_for(:janko))
  end

  describe "create" do
    it "keeps the fields filled in on validation errors" do
      visit new_game_path

      choose @quiz.name
      choose "2 igrača"
      fill_in "Korisničko ime", with: @matija.username
      click_on "Započni kviz"

      find_field(@quiz.name).should be_checked
      find_field("2 igrača").should be_checked
      find_field("Korisničko ime").value.should_not be_nil
    end

    context "with 1 player" do
      def fill_in_the_form
        choose @quiz.name
        choose "1 igrač"
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
        choose "2 igrača"
        fill_in "Korisničko ime", with: attributes_for(:matija)[:username]
        fill_in "Lozinka", with: attributes_for(:matija)[:password]
      end

      it "doesn't let the same student to be authenticated again" do
        visit new_game_path

        choose @quiz.name
        choose "2 igrača"
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
      choose "1 igrač"
      click_on "Započni kviz"
    end

    it "doesn't raise errors when questions are not answered" do
      start_game

      while current_path == edit_game_path
        click_on "Odgovori"
        within(".buttons") { find("a").click }
      end

      first(".bar").text.strip.should eq "0%"
    end

    it "displays after each answer whether that answer was correct" do
      start_game

      category = first("form")[:class].split(" ").last
      answer_question(category)
      click_on "Odgovori"

      page.should have_content("Točan odgovor")

      click_on "Sljedeće pitanje"
      click_on "Odgovori"

      page.should have_content("Netočan odgovor")
    end

    describe "giving up" do
      it "has a link" do
        start_game
        click_on "Prekini"
        current_path.should eq delete_game_path
      end

      it "can be canceled" do
        start_game
        visit delete_game_path
        click_on "Nisam"
        current_path.should eq edit_game_path
      end

      it "can be confirmed" do
        start_game
        visit delete_game_path
        click_on "Jesam"
        current_path.should eq new_game_path
      end
    end

    it "isn't possible if the game is over" do
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
        choose "1 igrač"
        click_on "Započni kviz"
      end

      it "correctly sums up the score" do
        start_game

        while current_path == edit_game_path
          category = first("form")[:class].split(" ").last
          answer_question(category)
          click_on "Odgovori"
          within(".buttons") { find("a").click }
        end

        first(".bar").text.strip.should eq "100%"
      end
    end

    context "with 2 players" do
      def start_game
        visit new_game_path
        choose @quiz.name
        choose "2 igrača"
        fill_in "Korisničko ime", with: attributes_for(:matija)[:username]
        fill_in "Lozinka", with: attributes_for(:matija)[:password]
        click_on "Započni kviz"
      end

      it "correctly sums up the score" do
        start_game

        while current_path == edit_game_path
          category = first("form")[:class].split(" ").last
          answer_question(category)
          click_on "Odgovori"
          within(".buttons") { find("a").click }
        end

        all(".bar").map(&:text).map(&:strip).each { |str| str.should_not eq "0%" }
      end
    end
  end

  after(:all) { @school.destroy }
end
