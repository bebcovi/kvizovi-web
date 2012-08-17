# encoding: utf-8

school = School.find_by_username("mioc")
school.books.create! \
  title: "Antigona",
  author: "Sofoklo",
  era: Era.find_by_name("Antika")

