require "rack/test"

FactoryGirl.define do
  factory :boolean_question, aliases: [:question] do
    content "Stannis Baratheon won the war against King's Landing."
    answer false
  end

  factory :choice_question do
    content "Eliminate the bastard."
    provided_answers ["Jon Snow", "Robb Stark", "Bran Stark", "Ned Stark"]
  end

  factory :association_question do
    content "Connect Game of Thrones characters:"
    associations({
      "Sansa Stark"      => %("...but I don't want anyone smart, brave or good looking, I want Joffrey!"),
      "Tywin Lannister"  => %("Attacking Ned Stark in the middle of King Landing was stupid. Lannisters don't do stupid things."),
      "Tyrion Lannister" => %("Why is every god so vicious? Why aren't there gods of tits and wine?"),
      "Cercei Lannister" => %("Everyone except us is our enemy."),
    })
  end

  factory :text_question do
    content "Which family does Khaleesi belong to?"
    answer "Targaryen"
  end

  factory :image_question do
    content "Who is in the photo?"
    answer "Robb Stark"
    image Rack::Test::UploadedFile.new(Rails.root.join("features/support/fixtures/files/robb.jpg"), "image/jpeg")
  end
end rescue nil
