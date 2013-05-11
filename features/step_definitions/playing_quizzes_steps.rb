require "rack/test"
require "nokogiri"
require "ostruct"

Given(/^my students have played a quiz( realistically)?$/) do |questions|
  @quiz = Factory.create(:quiz, school: @user)
  if questions
    @quiz.questions = create_questions(20)
  else
    @quiz.questions = create_questions(2)
  end
  Factory.create_list(:student, 2, school: @user)
  @played_quiz = create_played_quiz(@quiz, @user.students)
end

Given(/^my student has played a quiz$/) do
  @quiz = Factory.create(:quiz, school: @user)
  @quiz.questions = create_questions(1)
  Factory.create_list(:student, 1, school: @user)
  @played_quiz = create_played_quiz(@quiz, @user.students)
end

def create_played_quiz(quiz, students)
  quiz_snapshot = QuizSnapshot.capture(OpenStruct.new(students: students, quiz: quiz))
  played_quiz = Factory.create(:played_quiz, quiz_snapshot: quiz_snapshot)
  played_quiz.students = students
  played_quiz
end

When(/^I begin the quiz in single player$/) do
  refresh
  choose @quiz.name
  choose "Samo ja"
  click_on "Započni kviz"
end

When(/^I begin the quiz in multi player$/) do
  refresh
  player = Factory.create(:other_student, school: @user.school)
  choose @quiz.name
  choose "Još netko"
  fill_in "Korisničko ime", with: player.username
  fill_in "Lozinka",        with: player.password
  click_on "Započni kviz"
end

When(/^I begin the quiz$/) do
  step "I begin the quiz in single player"
end

When(/^(?:I|we) answer all questions correctly$/) do
  loop do
    case
    when page.has_content?("Eliminate the bastard.")
      choose "Jon Snow"
    when page.has_content?("Connect Game of Thrones characters:")
      connect "Sansa Stark",      %("...but I don't want anyone smart, brave or good looking, I want Joffrey!")
      connect "Tywin Lannister",  %("Attacking Ned Stark in the middle of King Landing was stupid. Lannisters don't do stupid things.")
      connect "Tyrion Lannister", %("Why is every god so vicious? Why aren't there gods of tits and wine?")
      connect "Cercei Lannister", %("Everyone except us is our enemy.")
    when page.has_content?("Stannis Baratheon won the war against King’s Landing.")
      choose "Netočno"
    when page.has_content?("Who is in the photo?")
      fill_in "Odgovor", with: "Clint Eastwood"
    when page.has_content?("Which family does Khaleesi belong to?")
      fill_in "Odgovor", with: "Targaryen"
    else
      raise "Unknown question"
    end

    click_on "Odgovori"
    expect(page).not_to satisfy do |page|
      ["Ne baš…", "Pogrešno", "Nažalost, ne…"].any? { |content| page.has_content?(content) }
    end

    begin
      click_on "Sljedeće pitanje"
    rescue Capybara::ElementNotFound
      click_on "Rezultati"
      break
    end
  end
end

def connect(left, right)
  @index ||= 0
  divs = all(".association-pair")[@index].all("td")
  divs.first.fill_in :play_answer, with: left
  divs.last.fill_in :play_answer, with: right
  @index += 1
end

When(/^(?:I|we) answer all questions incorrectly$/) do
  loop do
    click_on "Odgovori"
    expect(page).to satisfy do |page|
      ["Ne baš…", "Pogrešno", "Nažalost, ne…"].any? { |content| page.has_content?(content) }
    end

    if page.has_link?("Sljedeće pitanje")
      click_on "Sljedeće pitanje"
    else
      click_on "Rezultati"
      break
    end
  end
end

When(/^I interrupt it$/) do
  click_on "Prekini"
  click_on "Jesam"
end

Then(/^(I|we) should get all points$/) do |who|
  total = (who == "I" ? 6 : 3)
  expect(Nokogiri::HTML(html).at(".player-one").text).to have_content("#{total} od #{total}")
  expect(Nokogiri::HTML(html).at(".player-two").text).to have_content("#{total} od #{total}") if who == "we"
end

Then(/^(I|we) should not get any points$/) do |who|
  expect(Nokogiri::HTML(html).at(".player-one").text).to have_content("0 od 6")
  expect(Nokogiri::HTML(html).at(".player-two").text).to have_content("0 od 6") if who == "we"
end

Then(/^I should still be able to play it$/) do
  loop do
    click_on "Odgovori"
    if page.has_link?("Sljedeće pitanje")
      click_on "Sljedeće pitanje"
    else
      click_on "Rezultati"
      break
    end
  end
end
