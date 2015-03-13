require "kvizovi/models/quiz"
require "kvizovi/models/question"

require "kvizovi/error"

module Kvizovi
  class Quizzes
    VALID_FIELDS = [:name, :image, :questions_attributes]

    def initialize(user)
      @user = user
    end

    def all
      @user.quizzes_dataset.newest
    end

    def find(id)
      all.with_pk!(id)
    end

    def create(attrs)
      quiz = Models::Quiz.new
      quiz.set_only(attrs, *VALID_FIELDS)
      @user.add_quiz(quiz)
    end

    def update(id, attrs)
      quiz = find(id)
      quiz.set_only(attrs, *VALID_FIELDS)
      quiz.save
    end

    def destroy(id)
      find(id).destroy
    end
  end
end
