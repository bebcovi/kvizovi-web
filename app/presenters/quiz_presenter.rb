# encoding: utf-8

class QuizPresenter < BasePresenter
  presents :quiz

  def name
    quiz.name
  end

  def questions_count
    quiz.questions.count
  end

  def grades
    ordinalize(quiz.grades).to_sentence
  end

  def visibility_icon
    simple_form_for quiz do |f|
      if quiz.activated?
        f.hidden_field(:activated, value: false) +
        f.button(:button, "", title: "Deaktiviraj", class: "enabled")
      else
        f.hidden_field(:activated, value: true) +
        f.button(:button, "", title: "Aktiviraj", class: "disabled")
      end
    end
  end

  def visible?
    quiz.activated? ? "Da" : "Ne"
  end

  def edit_button(text, options = {})
    @template.edit_button text, edit_quiz_path(quiz), options
  end

  def manage_questions_button(text, options = {})
    link_to text.prepend_icon("list-view"), quiz_questions_path(quiz), options
  end

  def delete_button(text, options = {})
    @template.delete_button text, quiz_path(quiz), options
  end
end
