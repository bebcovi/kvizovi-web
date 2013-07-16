# encoding: utf-8

school_key = School.find_by_username("mioc").key

Student.create!([
  {
    first_name: "Pero",
    last_name: "Perić",
    username: "pero",
    password: "pero",
    password_confirmation: "pero",
    email: "pero@peric.hr",
    grade: "3d",
    gender: "Muško",
    year_of_birth: 1991,
    school_key: school_key
  },
  {
    first_name: "Ana",
    last_name: "Anić",
    username: "ana",
    password: "ana",
    password_confirmation: "ana",
    email: "ana@anic.hr",
    grade: "4a",
    gender: "Žensko",
    year_of_birth: 1990,
    school_key: school_key
  }
])
