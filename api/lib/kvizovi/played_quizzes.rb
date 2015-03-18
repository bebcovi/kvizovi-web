require "kvizovi/models/played_quiz"

module Kvizovi
  class PlayedQuizzes
    def self.create(attributes, tokens)
      players = tokens.map { |token| Account.authenticate(:token, token) }
      Models::PlayedQuiz.create attributes.merge(
        player_ids: players.map(&:id),
      )
    end

    def initialize(user)
      @user = user
    end

    def search(as:, quiz_id: nil, page: 1, per_page: nil)
      played_quizzes = send("search_as_#{as}")
      played_quizzes = played_quizzes.where(quiz_id: quiz_id) if quiz_id
      played_quizzes = played_quizzes.paginate(Integer(page), Integer(per_page)) if per_page
      played_quizzes
    end

    private

    def search_as_creator
      Models::PlayedQuiz.where(quiz: @user.quizzes)
    end

    def search_as_player
      Models::PlayedQuiz.where(players: @user)
    end
  end
end
