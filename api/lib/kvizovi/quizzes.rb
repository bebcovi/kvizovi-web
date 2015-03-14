require "kvizovi/models/quiz"
require "kvizovi/models/question"

require "kvizovi/error"

module Kvizovi
  class Quizzes
    def self.search(q: nil, category: nil, page: 1, per_page: nil)
      quizzes = Models::Quiz.dataset
      quizzes = quizzes.search(q) if q
      quizzes = quizzes.where(category: category) if category
      if per_page
        page, per_page = Integer(page), Integer(per_page)
        quizzes = quizzes.limit(per_page, (page - 1) * per_page)
      end
      quizzes
    end

    def self.find(id)
      Models::Quiz.with_pk!(id)
    end

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
      @user.add_quiz(attrs)
    end

    def update(id, attrs)
      quiz = find(id)
      quiz.update(attrs)
      quiz
    end

    def destroy(id)
      find(id).destroy
    end

    private
  end
end
