class QuestionPresenter < BasePresenter
  presents :question

  def content(quiz)
    link_to question, quiz_question_path(quiz, question)
  end

  def edit_button(text, quiz)
    @template.edit_button text, edit_quiz_question_path(quiz, question)
  end

  def delete_button(text, quiz)
    @template.delete_button text, quiz_question_path(quiz, question)
  end
end
