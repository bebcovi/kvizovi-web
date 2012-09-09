# encoding: utf-8

FactoryGirl.define do
  factory :school do
    username  "mioc"
    password  "secret"
    name      "XV. Gimnazija"
    level     "Srednja"
    key       "mioc"
  end

  factory :student do
    username   "john"
    password   "secret"
    first_name "John"
    last_name  "Doe"
    grade      3
    school_key "mioc"
  end

  factory :quiz do
    name      "Antika"
    grades    [1]
  end

  factory :question do
    quiz_id  1
    category "boolean"
    content  "content"
    data     "true"
    points   3

    factory :photo_question do
      category   "photo"
      data       "answer"
      attachment Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/files/photo.jpg", "image/jpeg")
    end

    factory :boolean_question do
      category "boolean"
      data     "true"
    end

    factory :association_question do
      category "association"
      data     %w[Foo Bar Baz Foo Bar Baz]
    end

    factory :choice_question do
      category "choice"
      data     %w[Foo Bar Baz]
    end

    factory :text_question do
      category "text"
      data     "answer"
    end
  end
end
