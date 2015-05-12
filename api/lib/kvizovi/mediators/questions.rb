require "kvizovi/models"

module Kvizovi
  module Mediators
    class Questions
      def initialize(quiz)
        @quiz = quiz
      end

      def all
        @quiz.questions_dataset
      end

      def find(id)
        all.with_pk!(id)
      end

      def create(attrs)
        @quiz.add_question(attrs)
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
