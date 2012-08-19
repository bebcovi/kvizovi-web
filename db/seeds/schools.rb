# encoding: utf-8

region = Region.find_by_name("Grad Zagreb")
region.schools.create! [
  {
    username: "mioc",
    name: "XV. Gimnazija",
    password: "mioc",
    level: "srednja",
    key: "mioc"
  }
]
