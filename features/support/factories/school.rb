if $load_factories
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
    end
  end
end
