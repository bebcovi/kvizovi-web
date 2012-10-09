# encoding: utf-8

FactoryGirl.define do
  factory :student do
    first_name "Jon"
    last_name "Snow"
    grade 2
    gender "Muško"
    year_of_birth 1991
    username "jon"
    password "jon"
    school_id 1
  end
end
