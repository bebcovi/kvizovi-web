require "rack/test/uploaded_file"

FactoryGirl.define do
  factory :question do
    content "Content."

    factory :boolean_question, class: "BooleanQuestion" do
      data_attributes(answer: true)
    end

    factory :choice_question, class: "ChoiceQuestion" do
      data_attributes(provided_answers: ["Foo", "Bar", "Baz", "Abc"])
    end

    factory :association_question, class: "AssociationQuestion" do
      data_attributes(associations: {"Foo" => "Foo", "Bar" => "Bar", "Baz" => "Baz", "Abc" => "Abc"})
    end

    factory :text_question, class: "TextQuestion" do
      data_attributes(answer: "Answer")
    end

    factory :image_question, class: "ImageQuestion" do
      data_attributes(answer: "Answer", image_file: Rack::Test::UploadedFile.new("#{ROOT}/spec/fixtures/files/image.jpg", "image/jpeg"))
    end
  end
end
