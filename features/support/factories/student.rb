FactoryGirl.define do
  factory :student do
    first_name "Jon"
    last_name "Snow"
    grade "2d"
    gender "Muško"
    year_of_birth 1991
    sequence(:username) { |n| "jon#{n}" }
    password "wildlings"
    sequence(:email) { |n| "jon.snow#{n}@example.com" }
    school

    factory :other_student do
      first_name "Dranaerys"
      last_name "Targaryen"
      username "khaleesi"
      password "dragons"
    end
  end
end if $load_factories
