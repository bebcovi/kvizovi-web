FactoryGirl.define do
  factory :quiz do
    name "Some quiz"
    category "Some category"
    school
    activated true
  end
end if $load_factories
