Given(/^my quiz has some questions$/) do
  FactoryGirl.create(:question, quiz: @quiz, content: "Question 1")
  FactoryGirl.create(:question, quiz: @quiz, content: "Question 2")
  FactoryGirl.create(:question, quiz: @quiz, content: "Question 3")
end

When(/^I create a boolean question$/) do
  visit account_quizzes_path unless page.has_content?(@quiz)
  within(@quiz) { click_on "Pitanja" }
  click_on "Točno/netočno"
  fill_in "Tekst pitanja", with: "Are you a stupidhead?"
  fill_in "URL od slike", with: "http://3.bp.blogspot.com/-bnKL0iosAc8/UOmO_a_ujuI/AAAAAAAAmVI/R5aNBx_yx2w/s1600/flbp-girls-women-sexy-9.jpg"
  choose "Točno"
  click_on "Spremi"
  @question = @quiz.questions.last
end

When(/^I create a choice question$/) do
  ensure_on account_quiz_questions_path(@quiz)
  click_on "Ponuđeni odgovori"
  fill_in "Tekst pitanja",      with: "Are you a stupidhead?"
  attach_file "Slika", file_path("robb.jpg")
  fill_in "Ponuđeni odgovor 1", with: "No"
  fill_in "Ponuđeni odgovor 2", with: "Yes"
  fill_in "Ponuđeni odgovor 3", with: "Maybe"
  fill_in "Ponuđeni odgovor 4", with: "Probably not"
  click_on "Spremi"
  @question = @quiz.questions.last
end

When(/^I create an association question$/) do
  ensure_on account_quiz_questions_path(@quiz)
  click_on "Asocijacija"
  fill_in "Tekst pitanja",  with: "Are you a stupidhead?"
  fill_in("Asocijacija 1a", with: "Uhm..."); fill_in("Asocijacija 1b", with: "Yes")
  fill_in("Asocijacija 2a", with: "Uhm..."); fill_in("Asocijacija 2b", with: "No")
  fill_in("Asocijacija 3a", with: "Uhm..."); fill_in("Asocijacija 3b", with: "Maybe")
  fill_in("Asocijacija 4a", with: "Uhm..."); fill_in("Asocijacija 4b", with: "Probably not")
  click_on "Spremi"
  @question = @quiz.questions.last
end

When(/^I create a text question$/) do
  ensure_on account_quiz_questions_path(@quiz)
  click_on "Upiši točan odgovor"
  fill_in "Tekst pitanja", with: "Are you a stupidhead?"
  fill_in "Odgovor", with: "Yes"
  click_on "Spremi"
  @question = @quiz.questions.last
end

When(/^I update that question$/) do
  within(@question) { click_on "Izmijeni" }
  fill_in "Tekst pitanja", with: "Are you a moron?"
  click_on "Spremi"
end

When(/^I delete that question$/) do
  within(@question) { click_on "Izbriši" }
end

When(/^I change the order of my questions$/) do
  fill_in "quiz_questions_attributes_0_position", with: "1"
  fill_in "quiz_questions_attributes_1_position", with: "3"
  fill_in "quiz_questions_attributes_2_position", with: "2"
end

Then(/^I should be on the questions page$/) do
  expect(current_path).to eq account_quiz_questions_path(@quiz)
  expect(page.driver.request.request_method).to eq "GET"
end

Then(/^I should see that question$/) do
  expect(page).to have_content("Are you a stupidhead?")
end

Then(/^I should see the updated question$/) do
  expect(page).to have_content("Are you a moron?")
end

Then(/^I should not see that question$/) do
  expect(page).not_to have_content(@question.content)
end

Then(/^the order of questions should be different$/) do
  expect(all(".boolean_question").to_a[0]).to have_content("Question 1")
  expect(all(".boolean_question").to_a[1]).to have_content("Question 3")
  expect(all(".boolean_question").to_a[2]).to have_content("Question 2")
end
