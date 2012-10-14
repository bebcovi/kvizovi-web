FactoryGirl.define do
  factory :quiz do
    name "Name"
    grades [1]
    activated true
    school
  end
end
