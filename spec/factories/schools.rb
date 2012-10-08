FactoryGirl.define do
  factory :school do
    name     "MIOC"
    level    "Srednja"
    sequence(:username) { |n| "mioc #{n}" }
    password "mioc"
    key      "mioc"
    place    "Zagreb"
    region   "Grad Zagreb"
  end
end
