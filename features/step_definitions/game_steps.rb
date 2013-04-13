Given(/^another player is registered$/) do
  @other_player = FactoryGirl.create(:student, username: "other", password: "other", school: @user.school)
end

Given(/^my school has created a quiz for me named "(.*)"$/) do |name|
  @quiz = FactoryGirl.create(:quiz, name: name, school: @user.school)
end

Given(/^that quiz has the following (.*) questions/) do |type, table|
  questions = table.hashes.map do |attributes|
    case type
    when "choice"
      attributes["provided_answers"] = eval(attributes["provided_answers"])
    when "association"
      attributes["associations"] = eval(attributes["associations"])
    when "image"
      attributes["image"] = Rack::Test::UploadedFile.new(Rails.root.join("features/support/files/#{attributes["image"]}"), "image/jpeg")
    end

    @quiz.questions << FactoryGirl.create(:"#{type}_question", attributes)
  end
end

When(/^I fill in other player's credentials$/) do
  fill_in "Korisničko ime", with: @other_player.username
  fill_in "Lozinka",        with: @other_player.password
end

When(/^I connect "(.*)" with "(.*)"/) do |left, right|
  @index ||= 0
  within("form") do
    divs = all("li")[@index].all("div")
    divs.first.fill_in :game_answer, with: left
    divs.last.fill_in :game_answer, with: right
  end
  @index += 1
end
