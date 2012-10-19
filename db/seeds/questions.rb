# encoding: utf-8

quiz = Quiz.find_by_name("Opća kultura")

quiz.boolean_questions.create!(
  content: "Eiffelov toranj se nalazi u Berlinu.",
  data_attributes: {
    answer: false
  }
)

quiz.choice_questions.create!(
  content: "Kako se u grčkoj mitologiji zove div sa samo jednim okom?",
  data_attributes: {
    provided_answers: ["Kiklop", "Hezoid", "Titan", "Kim"]
  }
)

quiz.association_questions.create!(
  content: "Povežite autore s njihovim djelima:",
  data_attributes: {
    associations: {
      "Fjodor Dostojevski"      => "Zločin i kazna",
      "Lav Nikolajevič Tolstoj" => "Rat i mir",
      "Franz Kafka"             => "Proces",
      "Miguel de Cervantes"     => "Don Quijote"
    }
  }
)

quiz.image_questions.create!([
  {
    content: "Kojeg opakog junaka vesterna vidimo na slici?",
    data_attributes: {
      image_file: uploaded_file("clint_eastwood.jpg", "image/jpeg"),
      answer: "Clint Eastwood"
    }
  },
  {
    content: "U kojem se filmu proslavio glumac na slici (desno)?",
    data_attributes: {
      image_file: uploaded_file("back_to_the_future.jpg", "image/jpeg"),
      answer: "Povratak u budućnost"
    }
  }
])

quiz.text_questions.create!(
  content: "Koji je najveći planet Sunčevog sustava?",
  data_attributes: {
    answer: "Jupiter"
  }
)
