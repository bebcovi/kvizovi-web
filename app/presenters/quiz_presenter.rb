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

  def edit_button(text, options = {})
    @template.edit_button text, edit_quiz_path(quiz), options
  end

  def manage_questions_button(text, options = {})
    link_to text.prepend_icon("tasks"), quiz_questions_path(quiz), options
  end

  def delete_button(text, options = {})
    @template.delete_button text, quiz_path(quiz), options
  end
end
