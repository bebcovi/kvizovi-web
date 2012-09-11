# encoding: utf-8

quiz = Quiz.find_by_name("Opća kultura")
quiz.questions.create! [
  {
    category: "boolean",
    content: "Eiffelov toranj se nalazi u Berlinu.",
    data: "false",
    points: 1
  },
  {
    category: "choice",
    content: "Kako se u grčkoj mitologiji zove div sa samo jednim okom?",
    data: ["Kiklop", "Hezoid", "Titan", "Kim"],
    points: 1
  },
  {
    category: "association",
    content: "Povežite autore s njihovim djelima:",
    data: [
      "Fjodor Dostojevski", "Zločin i kazna",
      "Lav Nikolajevič Tolstoj", "Rat i mir",
      "Franz Kafka", "Proces",
      "Miguel de Cervantes", "Don Quijote"
    ],
    points: 2
  },
  {
    category: "photo",
    content: "Kojeg opakog junaka vesterna vidimo na slici?",
    attachment: uploaded_file("clint_eastwood.jpg", "image/jpeg"),
    data: "Clint Eastwood",
    points: 2
  },
  {
    category: "photo",
    content: "U kojem se filmu proslavio glumac na slici (desno)?",
    attachment: uploaded_file("back_to_the_future.jpg", "image/jpeg"),
    data: "Povratak u budućnost",
    points: 2
  },
  {
    category: "text",
    content: "Koji je najveći planet Sunčevog sustava?",
    data: "Jupiter",
    points: 3
  }
]
