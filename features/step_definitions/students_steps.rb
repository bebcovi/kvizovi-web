Given(/^I have some students$/) do
  FactoryGirl.create_list(:student, 3, school: @user)
end

When(/^I go to the page for viewing students$/) do
  ensure_on account_quizzes_path
  click_on "Učenici"
end

Then(/^I should see those students/) do
  @user.students.each do |student|
    expect(page).to have_content(student.username)
    expect(page).to have_content(student.full_name)
  end
end
