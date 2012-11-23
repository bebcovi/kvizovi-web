# encoding: utf-8

class RemoveLeftoversFromExampleQuiz < ActiveRecord::Migration
  class Question < ActiveRecord::Base
    has_and_belongs_to_many :quizzes, foreign_key: "question_id"
  end
  class BooleanQuestion     < Question; end
  class ChoiceQuestion      < Question; end
  class AssociationQuestion < Question; end
  class ImageQuestion       < Question; end
  class TextQuestion        < Question; end

  def up
    ActiveRecord::Base.record_timestamps = false
    Question.includes(:quizzes).where("quizzes.id IS NULL").where(
      content: [
        %("Antigona" je komedija.),
        %(Antigona je kći tebanskog kralja Edipa.),
        %(Tko je napisao "Antigonu"?),
        %(Kako se zove Antigonin zaručnik?),
        %(Uz likove iz "Antigone" pridruži odgovarajuće opise:),
        %(Kako je počinjao pojedini čin?),
        %(Koji je ovo grčki tragičar?),
        %(Koji je ovo lik iz "Antigone"?),
        %(U kojem se gradu odvija radnja "Antigone"?),
        %(Tko je Antigonin i Izmenin otac?)
      ]
    ).destroy_all
    ActiveRecord::Base.record_timestamps = true
  end

  def down
  end
end
