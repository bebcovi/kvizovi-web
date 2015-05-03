require "kvizovi/mappers/base"

module Kvizovi
  module Mappers
    class GameplayMapper < Base
      attributes :id, :quiz_snapshot, :players_count, :answers, :start, :finish

      has_many :players, mapper: UserMapper
      has_one  :quiz

      def players_count
        object.player_ids.count
      end
    end
  end
end
