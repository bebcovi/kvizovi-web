When(/^I go to the page for monitoring that quiz$/) do
  refresh
  within(@quiz) { click_on "Prati" }
end

When(/^I go to the page for monitoring that student's activity$/) do
  click_on "Učenici"
  within(@user.students.first) { click_on "#{@user.students.first.played_quizzes.count}" }
end

When(/^I click on the played quiz$/) do
  within(@played_quiz) { click_on @played_quiz.name }
end

When(/^I go to that played quiz$/) do
  visit played_quizzes_url(subdomain: @user_type)
  within(@played_quiz) { click_on @played_quiz.name }
end

Then(/^I should see (?:their|his) results$/) do
  @played_quiz.questions.first(1).each do |question|
    expect(page).to have_content(question.content)
  end
end

Then(/^I should see that (?:they|he) played that quiz$/) do
  expect(find(".table")).to have_content(@played_quiz.name)
end
