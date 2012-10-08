# encoding: utf-8

quiz = Quiz.find_by_name("Opća kultura")

quiz.boolean_questions.create!(
  content: "Eiffelov toranj se nalazi u Berlinu.",
  answer: "false"
)
quiz.choice_questions.create!(
  content: "Kako se u grčkoj mitologiji zove div sa samo jednim okom?",
  provided_answers: ["Kiklop", "Hezoid", "Titan", "Kim"]
)

quiz.association_questions.create!(
  content: "Povežite autore s njihovim djelima:",
  associations: {
    "Fjodor Dostojevski"      => "Zločin i kazna",
    "Lav Nikolajevič Tolstoj" => "Rat i mir",
    "Franz Kafka"             => "Proces",
    "Miguel de Cervantes"     => "Don Quijote"
  }
)

quiz.image_questions.create!([
  {
    content: "Kojeg opakog junaka vesterna vidimo na slici?",
    image: uploaded_file("clint_eastwood.jpg", "image/jpeg"),
    answer: "Clint Eastwood"
  },
  {
    content: "U kojem se filmu proslavio glumac na slici (desno)?",
    image: uploaded_file("back_to_the_future.jpg", "image/jpeg"),
    answer: "Povratak u budućnost"
  }
])

quiz.text_questions.create!(
  content: "Koji je najveći planet Sunčevog sustava?",
  answer: "Jupiter"
)
