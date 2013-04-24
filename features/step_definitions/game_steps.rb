require "rack/test"
require "nokogiri"

Given(/^my school has created a quiz for me$/) do
  @quiz = Factory.create(:quiz, school: @user.school)

  @quiz.questions = [
    ChoiceQuestion.create!(
      content: "Who is the cutest person in the world?",
      provided_answers: ["Kina Grannis", "Me", "Jon Lajoie", "Matija"],
    ),
    AssociationQuestion.create!(
      content: "Connect browsers:",
      associations: {
        "IE"      => "Terrible as fuck",
        "Opera"   => "Weird",
        "Firefox" => "OK",
        "Chrome"  => "Best",
      },
    ),
    BooleanQuestion.create!(
      content: "This website is fucking awesome.",
      answer: true,
    ),
    ImageQuestion.create!(
      content: "Who is in the photo?",
      image: Rack::Test::UploadedFile.new(Rails.root.join("features/support/fixtures/files/clint_eastwood.jpg"), "image/jpeg"),
      answer: "Clint Eastwood",
    ),
    TextQuestion.create!(
      content: "What is Mr. Andersen’s hacker name?",
      answer: "Neo",
    ),
    TextQuestion.create!(
      content: "What was Smith’s name in the real world?",
      answer: "Bane",
    ),
  ]
end

Given(/^another student is registered$/) do
  @other_student = Factory.create(:other_student, school: @user.school)
end

When(/^I choose the quiz that my school has created for me$/) do
  choose @quiz.name
end

When(/^I choose to play alone$/) do
  choose "Samo ja"
end

When(/^I choose to play with the other student$/) do
  choose "Još netko"
  fill_in "Korisničko ime", with: @other_student.username
  fill_in "Lozinka",        with: @other_student.password
end

When(/^(I|we) answer all questions correctly$/) do |_|
  loop do
    case
    when page.has_content?("Who is the cutest person in the world?")
      choose "Kina Grannis"
    when page.has_content?("Connect browsers:")
      connect "IE",      "Terrible as fuck"
      connect "Opera",   "Weird"
      connect "Firefox", "OK"
      connect "Chrome",  "Best"
    when page.has_content?("This website is fucking awesome.")
      choose "Točno"
    when page.has_content?("Who is in the photo?")
      fill_in "Odgovor", with: "Clint Eastwood"
    when page.has_content?("What is Mr. Andersen’s hacker name?")
      fill_in "Odgovor", with: "Neo"
    when page.has_content?("What was Smith’s name in the real world?")
      fill_in "Odgovor", with: "Bane"
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
  within("form") do
    divs = all("li")[@index].all("div")
    divs.first.fill_in :game_answer, with: left
    divs.last.fill_in :game_answer, with: right
  end
  @index += 1
end

When(/^I answer all questions incorrectly$/) do
  loop do
    click_on "Odgovori"
    expect(page).to satisfy do |page|
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

When(/^I start the quiz$/) do
  visit new_game_url(subdomain: @user_type)
  choose @quiz.name
  choose "Samo ja"
  click_on "Započni kviz"
end

When(/^I interrupt the game$/) do
  click_on "Prekini"
  click_on "Jesam"
end

Then(/^(I|we) should see the first question$/) do |_|
  expect(page).to satisfy do |page|
    @quiz.questions.pluck(:content).any? { |content| page.has_content?(content) }
  end
end

Then(/^I should get all points$/) do
  expect(Nokogiri::HTML(html).at(".player_one").text).to have_content("6 od 6")
end

Then(/^we should get all points$/) do
  expect(Nokogiri::HTML(html).at(".player_one").text).to have_content("3 od 3")
  expect(Nokogiri::HTML(html).at(".player_two").text).to have_content("3 od 3")
end

Then(/^I should not get any points$/) do
  expect(Nokogiri::HTML(html).at(".player_one").text).to have_content("0 od 6")
end
