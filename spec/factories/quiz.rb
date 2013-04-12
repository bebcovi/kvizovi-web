FactoryGirl.define do
  factory :quiz do
    name "Name"
    school_id 1
    activated true
  end

  factory :empty_quiz, class: "Quiz"
end
