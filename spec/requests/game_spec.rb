# encoding: utf-8
require "spec_helper_full"

describe "Game" do
  # before(:all) do
  #   School.destroy_all
  #   Student.destroy_all

  #   @school = create(:school)
  #   @student = create(:student, username: "janko")
  #   @student2 = create(:student, username: "matija")
  #   @quiz = create(:quiz, activated: true, school: @school)
  #   create(:boolean_question, quiz: @quiz)
  #   create(:choice_question, quiz: @quiz)
  #   create(:association_question, quiz: @quiz)
  #   create(:photo_question, quiz: @quiz)
  #   create(:text_question, quiz: @quiz)
  # end

  # before(:each) do
  #   login(@student)
  #   @student2.stub(:password_plain) { attributes_for(:student)[:password] }
  # end

  # describe "create" do
  #   context "1 player" do
  #     it "works" do
  #       visit new_game_path
  #       choose @quiz.name
  #       choose "1 igrač"
  #       click_on "Započni"

  #       current_path.should eq(edit_game_path)
  #     end
  #   end

  #   context "2 players" do
  #     it "redirects back on unsuccessful authentication" do
  #       visit new_game_path
  #       choose @quiz.name
  #       choose "2 igrača"
  #       fill_in "Korisničko ime", with: @student2.username
  #       fill_in "Lozinka", with: "wrong"
  #       click_on "Započni"

  #       current_path.should eq(game_path)
  #       find_field("Korisničko ime").value.should eq(@student2.username)
  #       find_field("Lozinka").value.should be_nil
  #     end

  #     it "successfully authenticates the other player" do
  #       visit new_game_path
  #       choose @quiz.name
  #       choose "2 igrača"
  #       fill_in "Korisničko ime", with: @student2.username
  #       fill_in "Lozinka", with: @student2.password_plain
  #       click_on "Započni"

  #       current_path.should eq(edit_game_path)
  #     end
  #   end
  # end

  # describe "play" do
  #   def start_game
  #     visit new_game_path
  #     choose @quiz.name
  #     choose "1 igrač"
  #     click_on "Započni"
  #   end

  #   it "has a button to terminate the game" do
  #     start_game
  #     click_on "Prekini"
  #     current_path.should eq(new_game_path)
  #   end

  #   it "doesn't raise errors when nothing is answered" do
  #     start_game

  #     while current_path == edit_game_path
  #       expect { click_on "Odgovori" }.to_not raise_error
  #     end

  #     Game.last.scores.first.should eq(0)
  #   end

  #   def answer_incorrectly(question)
  #     if question.boolean?
  #       choose ["true", "false"].find { |answer| question.answer != answer }
  #       click_on "Odgovori"
  #     elsif question.choice?
  #       choose question.provided_answers.find { |answer| question.answer != answer }
  #       click_on "Odgovori"
  #     elsif question.association?
  #       span = within("game_answer_2") { first("span") }
  #       # Make sure the first answer is wrong
  #       if span.text == question.answer.values.first
  #         span.drag_to "#game_answer_4"
  #       end
  #       click_on "Odgovori"
  #     elsif question.photo?
  #       fill_in "Odgovor", with: "wrong"
  #     elsif question.text?
  #       fill_in "Odgovor", with: "wrong"
  #     end
  #   end

  #   def answer_correctly(question)
  #     if question.boolean?
  #       choose question.answer
  #       click_on "Odgovori"
  #     elsif question.choice?
  #       choose question.answer
  #       click_on "Odgovori"
  #     elsif question.association?
  #       n = 0
  #       while field = find("#game_answer_#{(n + 1) * 2}")
  #         if field.first("span").text != question.answer.values[n]
  #           field.first("span").drag_to "#game_answer_#{(n + 2) * 2}"
  #         end
  #         n += 1
  #       end
  #       click_on "Odgovori"
  #     elsif question.photo?
  #       fill_in "Odgovor", with: question.answer
  #     elsif question.text?
  #       fill_in "Odgovor", with: question.answer
  #     end
  #   end

  #   def current_question
  #     Question.find(session[:game][:questions].keys[session[:game][:current_question]])
  #   end

  #   context "1 player" do
  #     def start_game
  #       visit new_game_path
  #       choose @quiz.name
  #       choose "1 igrač"
  #       click_on "Započni"
  #     end

  #     context "wrong answers" do
  #       it "correctly calculates the score" do
  #         start_game

  #         while current_path == edit_game_path
  #           answer_incorrectly(current_question)
  #         end

  #         Game.last.scores.first.should eq(0)
  #       end
  #     end

  #     context "right answers" do
  #       it "correctly calculates the score" do
  #         start_game

  #         while current_path == edit_game_path
  #           answer_correctly(current_question)
  #         end

  #         game = Game.last
  #         maximum_score = game.questions.count / game.players.count
  #         game.scores.first.should eq(maximum_score)
  #       end
  #     end
  #   end

  #   context "2 players" do
  #     def start_game
  #       visit new_game_path
  #       choose @quiz.name
  #       choose "2 igrača"
  #       fill_in "Korisničko ime", with: @student2.username
  #       fill_in "Lozinka", with: @student2.password_plain
  #       click_on "Započni"
  #     end

  #     it "alternates players" do
  #       start_game

  #       n = 0
  #       usernames = [@student.username, @student2.username]
  #       while current_path == edit_game_path
  #         find(".username").should have_content usernames[n % 2]
  #         n += 1
  #       end
  #     end

  #     context "wrong answers" do
  #       it "correctly calculates the score" do
  #         start_game

  #         while current_path == edit_game_path
  #           answer_incorrectly(current_question)
  #         end

  #         Game.last.scores.should eq([0, 0])
  #       end
  #     end

  #     context "right answers" do
  #       it "correctly calculates the score" do
  #         start_game

  #         while current_path == edit_game_path
  #           answer_correctly(current_question)
  #         end

  #         game = Game.last
  #         maximum_score = game.questions.count / game.players.count
  #         game.scores.should eq([maximum_score, maximum_score])
  #       end
  #     end
  #   end
  # end

  # after(:all) do
  #   School.destroy_all
  #   Student.destroy_all
  #   Game.destroy_all
  # end
end
