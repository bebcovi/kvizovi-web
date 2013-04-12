require "rack/test/uploaded_file"

FactoryGirl.define do
  factory :boolean_question do
    content "Content."
    answer true
  end
  factory :empty_boolean_question, class: "BooleanQuestion"

  factory :choice_question do
    content "Content."
    provided_answers ["Foo", "Bar", "Baz", "Abc"]
  end
  factory :empty_choice_question, class: "ChoiceQuestion"

  factory :association_question do
    content "Content."
    associations({"Foo" => "Foo", "Bar" => "Bar", "Baz" => "Baz", "Abc" => "Abc"})
  end
  factory :empty_association_question, class: "AssociationQuestion"

  factory :text_question do
    content "Content."
    answer "Answer"
  end
  factory :empty_text_question, class: "TextQuestion"

  factory :image_question do
    content "Content."
    answer "Answer"
    image Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/files/image.jpg"), "image/jpeg")
  end
  factory :empty_image_question, class: "ImageQuestion"

  factory :question,       parent: :boolean_question
  factory :empty_question, parent: :empty_boolean_question
end
