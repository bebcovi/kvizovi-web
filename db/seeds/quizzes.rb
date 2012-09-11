# encoding: utf-8

school = School.find_by_username("mioc")
school.quizzes.create! [
  {name: "Opća kultura", grades: [1, 2, 4], activated: true}
]
