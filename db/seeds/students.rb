# encoding: utf-8

school_key = School.find_by_username("mioc").key
Student.create! [
  {
    first_name: "Janko",
    last_name: "Marohnić",
    username: "junky",
    password: "junky",
    grade: "4",
    school_key: school_key
  },
  {
    first_name: "Matija",
    last_name: "Marohnić",
    username: "matija",
    password: "matija",
    grade: "3",
    school_key: school_key
  }
]
