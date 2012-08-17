# encoding: utf-8

School.delete_all
school = School.create! \
  username: "mioc",
  name: "XV. Gimnazija",
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
quiz = school.quizzes.create!(name: "Antika", grade: 1)

Question.delete_all
quiz.questions.create! [
  {
    category: Question::CATEGORIES.key(:boolean),
    content: "Je li Eshil napisao knjigu \"Okovani Prometej\"?",
    data: {boolean: "true"},
    points: 2
  },
  {
    category: Question::CATEGORIES.key(:choice),
    content: "Izbacite uljeza:",
    data: {choice: ["Hipolit", "Pribjeglice", "Sedmorica protiv Tebe", "Okovani Prometej"]},
    points: 1
  },
  {
    category: Question::CATEGORIES.key(:association),
    content: "Povežite autore s njihovim djelima:",
    data: {association: ["Okovani Prometej", "Antigona", "Hipolit", "Eshil", "Sofoklo", "Euripid"]},
    points: 2
  },
  {
    category: Question::CATEGORIES.key(:photo),
    content: "Koji grčki tragičar je na slici?",
    attachment: Rack::Test::UploadedFile.new("#{Rails.root}/db/seeds/Eshil.jpg", "image/jpeg"),
    data: {photo: "Eshil"},
    points: 1
  },
  {
    category: Question::CATEGORIES.key(:text),
    content: "Koji grčki tragičar je napisao knjigu \"Hipolit\"?",
    data: {text: "Euripid"},
    points: 1
  }
]
