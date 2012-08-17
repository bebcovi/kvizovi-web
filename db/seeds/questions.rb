# encoding: utf-8

quiz = Quiz.find_by_name("Antika")
quiz.questions.create! [
  {
    category: category(:boolean),
    content: "Je li Eshil napisao knjigu \"Okovani Prometej\"?",
    data: {boolean: "true"},
    points: 2
  },
  {
    category: category(:choice),
    content: "Izbacite uljeza:",
    data: {choice: ["Hipolit", "Pribjeglice", "Sedmorica protiv Tebe", "Okovani Prometej"]},
    points: 1
  },
  {
    category: category(:association),
    content: "Povežite autore s njihovim djelima:",
    data: {association: ["Okovani Prometej", "Antigona", "Hipolit", "Eshil", "Sofoklo", "Euripid"]},
    points: 2
  },
  {
    category: category(:photo),
    content: "Koji grčki tragičar je na slici?",
    attachment: uploaded_file("Eshil.jpg", "image/jpeg"),
    data: {photo: "Eshil"},
    points: 1
  },
  {
    category: category(:text),
    content: "Koji grčki tragičar je napisao knjigu \"Hipolit\"?",
    data: {text: "Euripid"},
    points: 1
  }
]
