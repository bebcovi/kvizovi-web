require "kvizovi/configuration/sequel"
require "kvizovi/models/quiz"
require "kvizovi/models/user"

module Kvizovi
  module Models
    class PlayedQuiz < Sequel::Model
      many_to_one :quiz
      pg_array_to_many :players, class: User

      def to_json(**options)
        super(
          only: [:id, :quiz_id, :quiz_snapshot, :answers, :start, :finish],
          include: [:players],
          **options,
        )
      end
    end
  end
end
