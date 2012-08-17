# encoding: utf-8

school = School.find_by_username("mioc")
school.quizzes.create! [
  {
    name: "Antika",
    grade: 1
  }
]
