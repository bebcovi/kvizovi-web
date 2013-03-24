FactoryGirl.define do
  factory :school do
    name     "MIOC"
    level    "Srednja"
    sequence(:username) { |n| "mioc#{n}" }
    password "mioc"
    sequence(:email) { |n| "mioc#{n}@skola.hr" }
    key      "mioc"
    place    "Zagreb"
    region   "Grad Zagreb"

    factory :other_school do
      username "other"
      email "other@skola.hr"
    end
  end
end
