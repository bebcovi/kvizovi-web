require "active_record"
require "activerecord-postgres-hstore"

class Game < ActiveRecord::Base
  serialize :question_answers, ActiveRecord::Coders::Hstore
  serialize :question_ids, Array

  def self.create_from_info(hash)
    create(
      quiz_id: hash[:quiz_id],
      question_answers: Hash[hash[:question_ids].zip(hash[:question_answers])],
      question_ids: hash[:question_ids],
      duration: hash[:duration],
      interrupted: hash[:interrupted],
      first_player_id: hash[:player_ids].first,
      second_player_id: hash[:player_ids].last,
    )
  end
end
