# encoding: utf-8

School.delete_all
school = School.create! \
  username: "mioc",
  full_name: "XV. Gimnazija",
  password: "mioc",
  level: "srednja",
  key: "mioc"

Student.delete_all
school.students.create! \
  first_name: "Janko",
  last_name: "Marohnić",
  username: "junky",
  password: "junky",
  grade: "4"
school.students.create! \
  first_name: "Matija",
  last_name: "Marohnić",
  username: "matija",
  password: "matija",
  grade: "3"

Quiz.delete_all
quiz = school.quizzes.create!(name: "Antika", password: "antika")

Question.delete_all
quiz.questions.create! [
  {
    category: Question::CATEGORIES.key(:boolean),
    content: "Je li Magellan prvi oplovio svijet?",
    data: {boolean: "true"},
    points: 2
  },
  {
    category: Question::CATEGORIES.key(:choice),
    content: "Izbacite uljeza:",
    data: {choice: ["Internet Explorer", "Mozzila Firefox", "Google Chrome", "Safari"]},
    points: 1
  },
  {
    category: Question::CATEGORIES.key(:association),
    content: "Povežite pojmove:",
    data: {association: ["Ruby", "Internet Explorer", "Twitter", "Rails", "Bad", "Good"]},
    points: 2
  },
  {
    category: Question::CATEGORIES.key(:text),
    content: "Kako se zove začetnik impresionizma?",
    data: {text: "Claude Monet"},
    points: 1
  }
]
