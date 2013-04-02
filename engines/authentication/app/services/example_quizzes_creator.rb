require "rack/test/uploaded_file"

class ExampleQuizzesCreator
  def initialize(school)
    @school = school
  end

  def create
    ActiveRecord::Base.transaction do
      questions = []

      questions << BooleanQuestion.create!(
        content: %("Antigona" je komedija.),
        answer: false,
      )

      questions << ChoiceQuestion.create!(
        content: %(Kako se zove Antigonin zaručnik?),
        provided_answers: [
          "Hemon",
          "Edip",
          "Eteoklo",
          "Kreont"
        ],
      )

      questions << AssociationQuestion.create!(
        content: %(Uz likove iz "Antigone" pridruži odgovarajuće opise:),
        associations: {
          "Kreont"    => "Tebanski kralj",
          "Tiresija"  => "Prorok",
          "Hemon"     => "Antigonin zaručnik"
        },
      )

      questions << ImageQuestion.create!(
        content: %(Koji je ovo lik iz "Antigone"?),
        image_file: Rack::Test::UploadedFile.new("#{Rails.root}/db/seeds/files/antigona.jpg", "image/jpeg"),
        answer: "Antigona",
      )

      questions << TextQuestion.create!(
        content: %(Tko je Antigonin i Izmenin otac?),
        answer: "Edip",
      )

      quiz = @school.quizzes.create!(name: "Antigona")
      questions.flatten.each do |question|
        question.quizzes << quiz
        question.update_attributes(school: @school)
      end
    end
  end
end
