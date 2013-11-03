When(/^I go to the page for monitoring that quiz$/) do
  visit account_quizzes_path unless page.has_content?(@quiz.name)
  within(@quiz) { click_on "Prati" }
end

When(/^I go to the page for monitoring that student's activity$/) do
  visit account_students_path
  student = @user.students.first
  within(student) { click_on student.played_quizzes.count }
end

When(/^I go to the page for monitoring quizzes$/) do
  ensure_on account_quizzes_path
  click_on "Odigrani kvizovi"
end

When(/^I click on the played quiz$/) do
  within(@played_quiz) { click_on @played_quiz.name }
end

When(/^I go to that played quiz$/) do
  visit played_quiz_path(@played_quiz)
end

Then(/^I should see (?:their|his) results$/) do
  expect(page).to have_content(@played_quiz.questions.first.content)
end

Then(/^I should see that (?:they|he) played that quiz$/) do
  expect(find(".table")).to have_content(@played_quiz.name)
end
