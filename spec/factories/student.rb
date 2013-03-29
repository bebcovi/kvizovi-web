FactoryGirl.define do
  factory :student do
    first_name "Jon"
    last_name "Snow"
    grade "2d"
    gender "Muško"
    year_of_birth 1991
    username "jon"
    password "jon"
    school_id 1

    factory :other_student do
      username "other"
    end

    trait :with_school do
      school
    end

    factory :janko do
      first_name "Janko"
      last_name "Marohnić"
      username "janko"
      password "janko"
    end

    factory :matija do
      first_name "Matija"
      last_name "Marohnić"
      username "matija"
      password "matija"
    end

    factory :player do
      sequence(:username) { |n| "jon_#{n}" }
    end
  end
end
