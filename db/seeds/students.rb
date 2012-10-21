# encoding: utf-8

school_key = School.find_by_username("mioc").key

Student.create!([
  {
    first_name: "Pero",
    last_name: "Perić",
    username: "pero",
    password: "pero",
    email: "pero.peric@pero.hr",
    grade: "3",
    gender: "Muško",
    year_of_birth: 1991,
    school_key: school_key
  },
  {
    first_name: "Ana",
    last_name: "Anić",
    username: "ana",
    password: "ana",
    email: "ana.anic@ana.hr",
    grade: "4",
    gender: "Žensko",
    year_of_birth: 1990,
    school_key: school_key
  }
])
