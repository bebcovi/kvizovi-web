# encoding: utf-8

quiz = Quiz.find_by_name("Antika")
quiz.questions.create! [
  {
    category: "boolean",
    content: "Eshil je napisao knjigu \"Okovani Prometej\".",
    data: "true",
    points: 2
  },
  {
    category: "choice",
    content: "Izbacite uljeza:",
    data: ["Hipolit", "Pribjeglice", "Sedmorica protiv Tebe", "Okovani Prometej"],
    points: 1
  },
  {
    category: "association",
    content: "Povežite autore s njihovim djelima:",
    data: ["Okovani Prometej", "Eshil", "Antigona", "Sofoklo", "Hipolit", "Euripid"],
    points: 2
  },
  {
    category: "photo",
    content: "Koji grčki tragičar je na slici?",
    attachment: uploaded_file("Eshil.jpg", "image/jpeg"),
    data: "Eshil",
    points: 1
  },
  {
    category: "text",
    content: "Koji grčki tragičar je napisao knjigu \"Hipolit\"?",
    data: "Euripid",
    points: 1
  }
]
