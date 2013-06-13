FactoryGirl.define do
  factory :school do
    name     "MIOC"
    level    "Srednja"
    sequence(:username) { |n| "mioc#{n}" }
    password "mioc"
    password_confirmation "mioc"
    sequence(:email) { |n| "mioc#{n}@skola.hr" }
    key      "mioc"
    place    "Zagreb"
    region   "Grad Zagreb"
  end
end rescue nil
