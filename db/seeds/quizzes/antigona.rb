# encoding: utf-8

school = School.find_by_username("mioc")

quiz = school.quizzes.create!([
  {name: "Antigona", grades: [1, 3, 4], activated: true}
]).first

quiz.boolean_questions.create!([
  {
    content: %("Antigona" je komedija.),
    data_attributes: {
      answer: false
    }
  },
  {
    content: %(Antigona je kći tebanskog kralja Edipa.),
    data_attributes: {
      answer: true
    }
  }
])

quiz.choice_questions.create!([
  {
    content: %(Tko je napisao "Antigonu"?),
    data_attributes: {
      provided_answers: [
        "Sofoklo",
        "Euripid",
        "Miguel de Cervantes",
        "Antun Gustav Matoš"
      ]
    }
  },
  {
    content: %(Kako se zove Antigonin zaručnik?),
    data_attributes: {
      provided_answers: [
        "Hemon",
        "Edip",
        "Eteoklo",
        "Kreont"
      ]
    }
  }
])

quiz.association_questions.create!([
  {
    content: %(Uz likove iz "Antigone" pridruži odgovarajuće opise:),
    data_attributes: {
      associations: {
        "Kreont"    => "Tebanski kralj",
        "Tiresija"  => "Prorok",
        "Hemon"     => "Antigonin zaručnik"
      }
    }
  },
  {
    content: %(Kako je počinjao pojedini čin?),
    data_attributes: {
      associations: {
         "Antigona i Izmena razgovaraju"                   => "Prvi čin",
         "Kreont daje proglas za Polinika"                 => "Drugi čin",
         "Stražar Antigonu dovodi Kreontu"                 => "Treći čin",
         "Hemon pokušava uvjeriti Kreonta da je u krivu"   => "Četvrti čin",
         "Antigona pjeva tužaljku o svom životu"           => "Peti čin",
         "Dolazi prorok Tiresija"                          => "Šesti čin",
         "Glasnik objavljuje Hemonovu smrt"                => "Sedmi čin"
      }
    }
  }
])

quiz.image_questions.create!([
  {
    content: %(Koji je ovo grčki tragičar?),
    data_attributes: {
      image_file: uploaded_file("sofoklo.jpg", "image/jpeg"),
      answer: "Sofoklo"
    }
  },
  {
    content: %(Koji je ovo lik iz "Antigone"?),
    data_attributes: {
      image_file: uploaded_file("antigona.jpg", "image/jpeg"),
      answer: "Antigona"
    }
  }
])

quiz.text_questions.create!([
  {
    content: %(U kojem se gradu odvija radnja "Antigone"?),
    data_attributes: {
      answer: "Tebi"
    }
  },
  {
    content: %(Tko je Antigonin i Izmenin otac?),
    data_attributes: {
      answer: "Edip"
    }
  }
])
