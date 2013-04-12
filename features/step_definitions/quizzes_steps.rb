Given(/^I click on "(.*)" under quiz/) do |text|
  within(@user.quizzes.first) { click_on text }
end
