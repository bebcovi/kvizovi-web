# encoding: utf-8

school = School.find_by_username("mioc")
school.eras.create! [
  {
    name: "Antika",
    start_year: -800,
    end_year: 600
  },
  {
    name: "Srednji vijek",
    start_year: 500,
    end_year: 1500
  },
  {
    name: "Renesansa",
    start_year: 1500,
    end_year: 1670
  },
  {
    name: "Klasicizam i Prosvjetiteljstvo",
    start_year: 1700,
    end_year: 1800
  },
  {
    name: "Romantizam",
    start_year: 1798,
    end_year: 1870
  },
  {
    name: "Realizam",
    start_year: 1820,
    end_year: 1920
  },
  {
    name: "Naturalizam",
    start_year: 1870,
    end_year: 1920
  },
  {
    name: "Egzistencijalizam",
    start_year: 1850,
    end_year: nil
  },
  {
    name: "Modernizam",
    start_year: 1910,
    end_year: 1965
  },
  {
    name: "Postmodernizam",
    start_year: 1965,
    end_year: nil
  }
]
