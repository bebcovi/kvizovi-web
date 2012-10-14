# encoding: utf-8

class QuizPresenter < BasePresenter
  presents :quiz

  def questions_count
    quiz.questions.count
  end

  def grades
    ordinalize(quiz.grades).to_sentence
  end

  def visibility_icon
    simple_form_for quiz, html: {class: "toggle-activation"} do |f|
      if quiz.activated?
        f.hidden_field(:activated, value: false) +
        f.button(:button, "", title: "Deaktiviraj", class: "enabled")
      else
        f.hidden_field(:activated, value: true) +
        f.button(:button, "", title: "Aktiviraj")
      end
    end
  end
end
