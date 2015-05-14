require "kvizovi/models"
require "kvizovi/utils"

module Kvizovi
  module Mediators
    class Quizzes
      def self.search(q: nil, category: nil, page: nil, **)
        quizzes = Models::Quiz.dataset
        quizzes = quizzes.search(q) if q
        quizzes = quizzes.where(category: category) if category
        quizzes = Utils.paginate(quizzes, page) if page
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
        find(id).update(attrs)
      end

      def destroy(id)
        find(id).destroy
      end
    end
  end
end
