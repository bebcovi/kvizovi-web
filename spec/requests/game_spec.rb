# encoding: utf-8
require "spec_helper_full"

describe "Game" do
  before(:all) do
    @school = create(:school)
    @janko = @school.students.create(attributes_for(:janko))
    @matija = @school.students.create(attributes_for(:matija))
    @quiz = create(:quiz, school: @school)
    @boolean_question = create(:boolean_question, quiz: @quiz)
    @choice_question = create(:choice_question, quiz: @quiz)
    @association_question = create(:association_question, quiz: @quiz)
    @image_question = create(:image_question, quiz: @quiz)
    @text_question = create(:text_question, quiz: @quiz)
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

    context "1 player" do
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

    context "2 players" do
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
      end

      first(".bar").text.strip.should eq "0%"
    end

    it "can be given up" do
      start_game
      click_on "Prekini"
      current_path.should eq new_game_path
    end

    def answer_question(category)
      case category
      when "boolean"
        answer = (@boolean_question.answer == "true" ? "Točno" : "Netočno")
        choose answer
      when "choice"
        choose @choice_question.answer
      when "association"
        (1..@association_question.associations.count).each do |n|
          fill_in "game_answer_#{n * 2}", with: @association_question.associations.right_side[n - 1]
        end
      when "image"
        fill_in "Odgovor", with: @image_question.answer
      when "text"
        fill_in "Odgovor", with: @text_question.answer
      end
    end

    context "1 player" do
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
        end

        first(".bar").text.strip.should eq "100%"
      end
    end

    context "2 players" do
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
        end

        all(".bar").map(&:text).map(&:strip).each { |str| str.should_not eq "0%" }
      end
    end
  end

  after(:all) { @school.destroy }
end
