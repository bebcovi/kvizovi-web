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

When(/^I begin the quiz(?: in single player)?$/) do
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

When(/^(?:I|we) answer all questions correctly$/) do
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
  divs = all(".association-pair")[@index].all("div")
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

When(/^in the meanwhile the quiz gets deleted$/) do
  @quiz.destroy
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
