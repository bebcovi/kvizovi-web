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
      text = "Deaktiviraj"
      options = {class: "quiz_toggle_activation enabled"}
    else
      text = "Aktiviraj"
      options = {class: "quiz_toggle_activation"}
    end

    link_to text, toggle_activation_quiz_path(quiz), options.merge(method: :put)
  end
end
