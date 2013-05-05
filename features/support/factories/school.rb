<<<<<<< HEAD
if $load_factories
  FactoryGirl.define do
    factory :school, aliases: [:user] do
      name     "MIOC"
      level    "Srednja"
      username "mioc"
      password "mioc"
      email    "mioc@skola.hr"
      key      "mioc"
      place    "Zagreb"
      region   "Grad Zagreb"
    end
=======
FactoryGirl.define do
  factory :school do
    name     "MIOC"
    level    "Srednja"
    username "mioc"
    password "mioc"
    email    "mioc@skola.hr"
    key      "mioc"
    place    "Zagreb"
    region   "Grad Zagreb"
>>>>>>> monitoring
  end
end if $load_factories
