FactoryGirl.define do
  factory :quiz do
    name "Some quiz"
    school
    activated true
  end
end if $load_factories
