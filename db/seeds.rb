require "database_cleaner"

DatabaseCleaner.clean_with :truncation

School.create!(
  name: "XV. Gimnazija",
  username: "mioc",
  password: "mioc",
  password_confirmation: "mioc",
  confirmed_at: Time.now,
  email: "mioc@mioc.hr",
  level: "Srednja",
  place: "Zagreb",
  region: "Grad Zagreb",
  key: "mioc",
  completed_survey: true,
)

Student.create!(
  first_name: "Janko",
  last_name: "Marohnić",
  username: "junky",
  password: "junky",
  password_confirmation: "junky",
  confirmed_at: Time.now,
  email: "junky@junky.hr",
  grade: "3d",
  gender: "Muško",
  year_of_birth: 1991,
  school: School.first,
  completed_survey: true,
)
