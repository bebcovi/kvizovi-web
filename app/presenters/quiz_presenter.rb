class QuizPresenter < BasePresenter
  presents :quiz

  def name
    quiz.name
  end

  def grades
    ordinalize(quiz.grades).to_sentence
  end

  def visibility_icon
    quiz.activated? ? icon("eye-open") : icon("eye-close")
  end

  def visible?
    quiz.activated? ? "Da" : "Ne"
  end

  def edit_button(text)
    @template.edit_button text, edit_quiz_path(quiz)
  end

  def delete_button(text)
    @template.delete_button text, quiz_path(quiz)
  end
end
