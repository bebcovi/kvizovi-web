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
    if quiz.activated?
      link_to icon("lamp-on"), toggle_activation_quiz_path(quiz), class: "toggle-activation btn btn-success", title: "Deaktiviraj", method: :put
    else
      link_to icon("lamp-off"), toggle_activation_quiz_path(quiz), class: "toggle-activation btn", title: "Aktiviraj", method: :put
    end
  end
end
