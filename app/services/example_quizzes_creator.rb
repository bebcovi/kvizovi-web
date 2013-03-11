require "rack/test/uploaded_file"

class ExampleQuizzesCreator
  def initialize(school)
    @school = school
  end

  def create
    quiz = @school.quizzes.create!(name: "Antigona")

    quiz.boolean_questions.create!(
      content: %("Antigona" je komedija.),
      answer: false,
    )

    quiz.choice_questions.create!(
      content: %(Kako se zove Antigonin zaručnik?),
      provided_answers: [
        "Hemon",
        "Edip",
        "Eteoklo",
        "Kreont"
      ],
    )

    quiz.association_questions.create!(
      content: %(Uz likove iz "Antigone" pridruži odgovarajuće opise:),
      associations: {
        "Kreont"    => "Tebanski kralj",
        "Tiresija"  => "Prorok",
        "Hemon"     => "Antigonin zaručnik"
      },
    )

    quiz.image_questions.create!(
      content: %(Koji je ovo lik iz "Antigone"?),
      image_file: Rack::Test::UploadedFile.new("#{Rails.root}/db/seeds/files/antigona.jpg", "image/jpeg"),
      answer: "Antigona",
    )

    quiz.text_questions.create!(
      content: %(Tko je Antigonin i Izmenin otac?),
      answer: "Edip",
    )

    quiz.questions.update_all(school_id: @school.id)
  end
end
