# encoding: utf-8

school_key = School.find_by_username("mioc").key
Student.create! [
  {
    first_name: "Pero",
    last_name: "Perić",
    username: "pero",
    password: "pero",
    grade: "3",
    gender: "Muško",
    year_of_birth: 1991,
    school_key: school_key
  }
]
