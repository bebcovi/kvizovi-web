require "rack/test/uploaded_file"

FactoryGirl.define do
  factory :question do
    content "Content."
  end

  factory :boolean_question do
    content "Content."
    answer "true"
  end

  factory :choice_question do
    content "Content."
    provided_answers ["Foo", "Bar", "Baz", "Abc"]
  end

  factory :association_question do
    content "Content."
    associations \
      "Foo" => "Foo",
      "Bar" => "Bar",
      "Baz" => "Baz",
      "Abc" => "Abc"
  end

  factory :text_question do
    content "Content."
    answer "Answer"
  end

  factory :image_question do
    content "Content."
    answer "Answer"
    image Rack::Test::UploadedFile.new("#{ROOT}/spec/fixtures/files/image.jpg", "image/jpeg")
  end
end
