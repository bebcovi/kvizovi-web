require "ostruct"

Given(/^my student(s)? (?:have|has) played a quiz( realistically)?$/) do |multiplayer, many_questions|
  @quiz = FactoryGirl.create(:quiz, school: @user)
  @quiz.questions = create_questions(many_questions ? 20 : 2)
  students = FactoryGirl.create_list(:student, multiplayer ? 2 : 1, school: @user)
  quiz_snapshot = QuizSnapshot.capture(OpenStruct.new(students: students, quiz: @quiz))
  @played_quiz = FactoryGirl.create(:played_quiz, quiz_snapshot: quiz_snapshot)
  @played_quiz.students = students
end

When(/^I begin the quiz(?: in single player)?$/) do
  visit choose_quiz_path unless page.has_content?(@quiz.name)
  choose @quiz.name
  choose "Samo ja"
  click_on "Započni kviz"
end

When(/^we begin the quiz in multi player$/) do
  visit choose_quiz_path unless page.has_content?(@quiz.name)
  other_student = FactoryGirl.create(:student, school: @user.school)
  choose @quiz.name
  choose "Još netko"
  fill_in "Korisničko ime", with: other_student.username
  fill_in "Lozinka",        with: other_student.password
  click_on "Započni kviz"
end

When(/^(?:I|we) answer all questions correctly$/) do
  answers do
    case
    when page.has_content?("Eliminate the bastard.")
      choose "Jon Snow"
    when page.has_content?("Connect Game of Thrones characters:")
      connect(
        "Sansa Stark"      => %("...but I don't want anyone smart, brave or good looking, I want Joffrey!"),
        "Tywin Lannister"  => %("Attacking Ned Stark in the middle of King Landing was stupid. Lannisters don't do stupid things."),
        "Tyrion Lannister" => %("Why is every god so vicious? Why aren't there gods of tits and wine?"),
        "Cercei Lannister" => %("Everyone except us is our enemy."),
      )
    when page.has_content?("Stannis Baratheon won the war against King’s Landing.")
      choose "Netočno"
    when page.has_content?("Which family does Khaleesi belong to?")
      fill_in "Odgovor", with: "Targaryen"
    else
      raise "Unknown question"
    end

    click_on "Odgovori"
    expect(page.title).to match "Točan odgovor"
  end
end

When(/^(?:I|we) answer all questions incorrectly$/) do
  answers do
    click_on "Odgovori"
    expect(page.title).to match "Netočan odgovor"
  end
end

When(/^I interrupt it$/) do
  click_on "Prekini"
  click_on "Jesam"
end

Then(/^(I|we) should get all points$/) do |who|
  if who == "I"
    expect(first(".l-player-one")).to have_content("6 od 6")
  else
    expect(first(".l-player-one")).to have_content("3 od 3")
    expect(first(".l-player-two")).to have_content("3 od 3")
  end
end

Then(/^(I|we) should not get any points$/) do |who|
  if who == "I"
    expect(first(".l-player-one")).to have_content("0 od 6")
  else
    expect(first(".l-player-one")).to have_content("0 od 3")
    expect(first(".l-player-two")).to have_content("0 od 3")
  end
end

Then(/^I should still be able to play it$/) do
  answers do
    click_on "Odgovori"
  end
end

Then(/^I should see that quiz in the list of available quizzes$/) do
  visit choose_quiz_path
  click_on "Druge škole"
  expect(find("#other")).to have_content(@quiz.name)
end

Then(/^I should be able to play it$/) do
  step "I begin the quiz"
  answers do
    click_on "Odgovori"
  end
end
