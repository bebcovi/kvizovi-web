class QuestionPresenter < BasePresenter
  presents :question

  def content
    question
  end

  def edit_button(text, quiz, options = {})
    @template.edit_button text, edit_quiz_question_path(quiz, question), options
  end

  def preview_button(text, quiz, options = {})
    @template.preview_button text, quiz_question_path(quiz, question), options
  end

  def delete_button(text, quiz, options = {})
    @template.delete_button text, quiz_question_path(quiz, question), options
  end
end
