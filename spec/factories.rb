# encoding: utf-8

FactoryGirl.define do
  factory :book do
    author "Lav Nikolajevič Tolstoj"
    title "Rat i mir"
    year 1869
  end

  factory :school do
    username  "mioc"
    full_name "XV. Gimnazija"
    password  "mioc"
    kind      "srednja"
    key       "mioc"
  end
end
