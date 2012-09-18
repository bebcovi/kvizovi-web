# encoding: utf-8

school_key = School.find_by_username("mioc").key
Student.create! [
  {
    first_name: "Pero",
    last_name: "Perić",
    username: "pero",
    password: "pero",
    grade: "3",
    school_key: school_key
  }
]
