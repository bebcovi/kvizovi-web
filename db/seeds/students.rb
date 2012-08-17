# encoding: utf-8

school = School.find_by_username("mioc")
school.students.create! [
  {
    first_name: "Janko",
    last_name: "Marohnić",
    username: "junky",
    password: "junky",
    grade: "4"
  },
  {
    first_name: "Matija",
    last_name: "Marohnić",
    username: "matija",
    password: "matija",
    grade: "3"
  }
]
