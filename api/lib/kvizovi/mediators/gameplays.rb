require "kvizovi/models"
require "kvizovi/utils"

module Kvizovi
  module Mediators
    class Gameplays
      def self.create(attributes)
        ids = attributes.delete(:associations)
        attributes.update(quiz_id: ids[:quiz], player_ids: ids[:players])
        Models::Gameplay.create attributes
      end

      def initialize(user)
        @user = user
      end

      def search(as:, quiz_id: nil, page: nil, **)
        gameplays = send("all_for_#{as}")
        gameplays = gameplays.where(quiz_id: quiz_id) if quiz_id
        gameplays = Utils.paginate(gameplays, page) if page
        gameplays.newest
      end

      def find(id)
        Models::Gameplay.with_pk!(id)
      end

      private

      def all_for_creator
        Models::Gameplay.where(quiz: @user.quizzes)
      end

      def all_for_player
        Models::Gameplay.where(players: @user)
      end
    end
  end
end
