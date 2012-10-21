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
    email "jon@snow.com"
    school_id 1

    factory :janko do
      first_name "Janko"
      last_name "Marohnić"
      username "janko"
      password "janko"
      email "janko.marohnic@gmail.com"
    end

    factory :matija do
      first_name "Matija"
      last_name "Marohnić"
      username "matija"
      password "matija"
      email "matija.marohnic@gmail.com"
    end

    factory :player do
      sequence(:username) { |n| "jon_#{n}" }
    end
  end
end
