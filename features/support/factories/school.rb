FactoryGirl.define do
  factory :school, aliases: [:user] do
    name     "MIOC"
    level    "Srednja"
    sequence(:username) { |n| "mioc#{n}" }
    password "mioc"
    sequence(:email) { |n| "mioc#{n}@skola.hr" }
    key      "mioc"
    place    "Zagreb"
    region   "Grad Zagreb"
  end
end if $load_factories
