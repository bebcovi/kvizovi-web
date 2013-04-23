FactoryGirl.define do
  factory :student do
    first_name "Jon"
    last_name "Snow"
    grade "2d"
    gender "Muško"
    year_of_birth 1991
    username "jon"
    password "wildlings"
    school

    factory :other_student do
      first_name "Dranaerys"
      last_name "Targaryen"
      username "khaleesi"
      password "dragons"
    end
  end

  factory :empty_student, class: "Student"
end
