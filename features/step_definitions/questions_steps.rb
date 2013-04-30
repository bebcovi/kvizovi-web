When(/^I create a boolean question$/) do
  visit quizzes_url(subdomain: @user_type)
  within(@quiz) { click_on "Pitanja" }
  click_on "Točno/netočno"
  fill_in "Tekst pitanja", with: "Are you a stupidhead?"
  choose "Točno"
  click_on "Spremi"
  @question = @quiz.questions.last
end

When(/^I create a choice question$/) do
  visit quiz_questions_url(@quiz, subdomain: @user_type)
  click_on "Ponuđeni odgovori"
  fill_in "Tekst pitanja",      with: "Are you a stupidhead?"
  fill_in "Ponuđeni odgovor 1", with: "No"
  fill_in "Ponuđeni odgovor 2", with: "Yes"
  fill_in "Ponuđeni odgovor 3", with: "Maybe"
  fill_in "Ponuđeni odgovor 4", with: "Probably not"
  click_on "Spremi"
  @question = @quiz.questions.last
end

When(/^I create an association question$/) do
  visit quiz_questions_url(@quiz, subdomain: @user_type)
  click_on "Asocijacija"
  fill_in "Tekst pitanja",  with: "Are you a stupidhead?"
  fill_in("Asocijacija 1a", with: "Uhm..."); fill_in("Asocijacija 1b", with: "Yes")
  fill_in("Asocijacija 2a", with: "Uhm..."); fill_in("Asocijacija 2b", with: "No")
  fill_in("Asocijacija 3a", with: "Uhm..."); fill_in("Asocijacija 3b", with: "Maybe")
  fill_in("Asocijacija 4a", with: "Uhm..."); fill_in("Asocijacija 4b", with: "Probably not")
  click_on "Spremi"
  @question = @quiz.questions.last
end

When(/^I create an image question with (.*)$/) do |image_input|
  visit quiz_questions_url(@quiz, subdomain: @user_type)
  click_on "Pogodi tko/što je na slici"
  fill_in "Tekst pitanja", with: "Are you a stupidhead?"
  case image_input
  when "image url"  then fill_in "URL od slike", with: "http://3.bp.blogspot.com/-bnKL0iosAc8/UOmO_a_ujuI/AAAAAAAAmVI/R5aNBx_yx2w/s1600/flbp-girls-women-sexy-9.jpg"
  when "image file" then attach_file "Slika", Rails.root.join("features/support/fixtures/files/clint_eastwood.jpg")
  end
  fill_in "Odgovor", with: "Yes"
  click_on "Spremi"
  @question = @quiz.questions.last
end

When(/^I create an image question$/) do
  step "I create an image question with image file"
end

When(/^I create a text question$/) do
  visit quiz_questions_url(@quiz, subdomain: @user_type)
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

When(/^I click on the undo link$/) do
  click_on "Vrati"
end

Then(/^I should be on the questions page$/) do
  expect(current_path).to eq quiz_questions_path(@quiz)
  expect(page.driver.request.request_method).to eq "GET"
end

Then(/^I should see that question(?: again)?$/) do
  expect(page).to have_content("Are you a stupidhead?")
end

Then(/^I should see the updated question$/) do
  expect(page).to have_content("Are you a moron?")
end

Then(/^I should not see that question$/) do
  expect(page).not_to have_content(@question.content)
end

Then(/^I should see an undo link$/) do
  expect(page).to have_content("Vrati")
end

def create_questions(number)
  question_creations = [
    proc do
      ChoiceQuestion.create!(
        content: "Eliminate the bastard.",
        provided_answers: ["Jon Snow", "Robb Stark", "Bran Stark", "Ned Stark"],
      )
    end, proc do
      AssociationQuestion.create!(
        content: "Connect Game of Thrones characters:",
        associations: {
          "Sansa Stark"      => %("...but I don't want anyone smart, brave or good looking, I want Joffrey!"),
          "Tywin Lannister"  => %("Attacking Ned Stark in the middle of King Landing was stupid. Lannisters don't do stupid things."),
          "Tyrion Lannister" => %("Why is every god so vicious? Why aren't there gods of tits and wine?"),
          "Cercei Lannister" => %("Everyone except us is our enemy."),
        },
      )
    end, proc do
      BooleanQuestion.create!(
        content: "Stannis Baratheon won the war against King's Landing.",
        answer: false,
      )
    end, proc do
      ImageQuestion.create!(
        content: "Who is in the photo?",
        image: Rack::Test::UploadedFile.new(Rails.root.join("features/support/fixtures/files/clint_eastwood.jpg"), "image/jpeg"),
        answer: "Clint Eastwood",
      )
    end, proc do
      TextQuestion.create!(
        content: "Which family does Khaleesi belong to?",
        answer: "Targaryen",
      )
    end,
  ]

  number.times.map do |idx|
    question_creations[idx % 5].call
  end
end
