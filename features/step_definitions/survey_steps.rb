When(/^I click on the link for survey$/) do
  click_on "Anketa"
end

When(/^I complete the survey$/) do
  school  { click_on "Ispunio/la sam anketu" }
  student { click_on "Ispuni#{@user.male? ? "o" : "la"} sam anketu" }
end

Then(/^I should (not )?see the link for the survey(?: anymore)?$/) do |negate|
  if negate.blank?
    expect(page).to have_link("Anketa")
  else
    expect(page).not_to have_link("Anketa")
  end
end
