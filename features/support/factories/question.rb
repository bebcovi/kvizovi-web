require "rack/test/uploaded_file"

FactoryGirl.define do
  factory :boolean_question, aliases: [:question] do
    content "Content."
    answer true
    quiz
  end

  factory :choice_question do
    content "Content."
    provided_answers ["Foo", "Bar", "Baz", "Abc"]
    quiz
  end

  factory :association_question do
    content "Content."
    associations({"Foo" => "Foo", "Bar" => "Bar", "Baz" => "Baz", "Abc" => "Abc"})
    quiz
  end

  factory :text_question do
    content "Content."
    answer "Answer"
    quiz
  end

  factory :image_question do
    content "Content."
    answer "Answer"
    image Rack::Test::UploadedFile.new(Rails.root.join("features/support/fixtures/files/clint_eastwood.jpg"), "image/jpeg")
    quiz
  end
end if $load_factories
