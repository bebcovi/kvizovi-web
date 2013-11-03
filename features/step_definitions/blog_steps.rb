Given(/^there is a new blog post$/) do
  @post = FactoryGirl.create(:post)
end

When(/^I leave the blog$/) do
  visit path_to("homepage")
end

When(/^I create a new blog post$/) do
  click_on "Novi post"
  fill_in "Naslov", with: "Blog post"
  fill_in "Sadržaj", with: "Blog post sadržaj"
  click_on "Spremi"
end

When(/^I update the blog post$/) do
  click_on "Izmijeni"
  fill_in "Naslov", with: "Blog post izmijenjeni"
  click_on "Spremi"
end

When(/^I delete the blog post$/) do
  click_on "Izbriši"
end

Then(/^I should see that I have an unread blog post$/) do
  expect(find(".navbar-inner").find(".badge")).to have_content("1")
end

Then(/^I should see the blog posts$/) do
  expect(page).to have_content(@post.title)
end

Then(/^I shouldn't have any unread blog posts$/) do
  expect(find(".navbar-inner")).not_to have_css(".badge")
end

Then(/^I should(n't)? see the admin links$/) do |negative|
  unless negative
    expect(page).to have_content("Novi post")
  else
    expect(page).not_to have_content("Novi post")
  end
end

Then(/^I should see the new blog post$/) do
  expect(page).to have_content("Blog post")
end

Then(/^I should see the updated blog post$/) do
  expect(page).to have_content("Blog post izmijenjeni")
end

Then(/^I shouldn't see the blog post$/) do
  expect(page).not_to have_content("Blog post izmijenjeni")
end
