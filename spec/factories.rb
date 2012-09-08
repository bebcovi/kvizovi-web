# encoding: utf-8

FactoryGirl.define do
  factory :school do
    username  "mioc"
    password  "secret"
    name      "XV. Gimnazija"
    level     "Srednja"
    key       "mioc"

    after(:stub) do |school|
      school.quizzes = []
    end
  end

  factory :student do
    before(:create) do
      create(:school) unless School.any?
    end

    username   "john"
    password   "secret"
    first_name "John"
    last_name  "Doe"
    grade      3
    school_key "mioc"

    after(:stub) do |student|
      student.school = build_stubbed(:school)
    end
  end

  factory :quiz do
    school_id 1
    name      "Name"
    grades    [1]
    activated true
  end

  factory :question do
    quiz_id  1
    category "boolean"
    content  "Question?"
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
