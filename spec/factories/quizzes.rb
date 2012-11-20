FactoryGirl.define do
  factory :quiz do
    name "Name"
    grades ["1a", "2b"]
    school_id 1
    activated true
  end
end
