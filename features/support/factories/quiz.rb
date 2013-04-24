if $load_factories
  FactoryGirl.define do
    factory :quiz do
      name "Name"
      school
      activated true
    end
  end
end
