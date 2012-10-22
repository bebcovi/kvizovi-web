require "rack/test/uploaded_file"

FactoryGirl.define do
  factory :boolean_question, aliases: [:question] do
    content "Content."
    data_attributes(answer: true)
  end

  factory :choice_question do
    content "Content."
    data_attributes(provided_answers: ["Foo", "Bar", "Baz", "Abc"])
  end

  factory :association_question do
    content "Content."
    data_attributes(associations: {"Foo" => "Foo", "Bar" => "Bar", "Baz" => "Baz", "Abc" => "Abc"})
  end

  factory :text_question do
    content "Content."
    data_attributes(answer: "Answer")
  end

  factory :image_question do
    content "Content."
    data_attributes(answer: "Answer", image_file: Rack::Test::UploadedFile.new("#{ROOT}/spec/fixtures/files/image.jpg", "image/jpeg"))
  end
end
