require "kvizovi/models/user"
require "kvizovi/models/quiz"
require "kvizovi/models/question"

module Kvizovi
  class Quizzes
    def initialize(user)
      @user = user
    end

    def all
      @user.quizzes_dataset.newest
    end

    def find(id)
      all.first!(id: id)
    end

    def create(quiz_attrs)
      questions_attrs = quiz_attrs.delete(:questions)

      quiz = @user.add_quiz(quiz_attrs)
      update(quiz.id, questions: questions_attrs)

      quiz
    end

    def update(id, quiz_attrs)
      questions_attrs = quiz_attrs.delete(:questions)

      quiz = find(id)
      quiz.update(quiz_attrs)

      return quiz if questions_attrs.nil?

      quiz.questions_dataset
        .exclude(id: questions_attrs.map { |h| h[:id] })
        .delete

      questions_attrs.each do |question_attrs|
        if question_id = question_attrs.delete(:id)
          question = quiz.questions_dataset.first(id: question_id)
          question.update(question_attrs)
        else
          quiz.add_question(question_attrs)
        end
      end

      quiz
    end

    def destroy(id)
      quiz = find(id)
      quiz.questions_dataset.delete
      quiz.destroy
    end
  end
end
