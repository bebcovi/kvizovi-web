class PlayedGame < ActiveRecord::Base
  serialize :question_answers, ActiveRecord::Coders::Hstore
  serialize :question_ids, Array

  def self.create_from_hash(hash)
    quiz_id          = hash[:quiz][:id]
    question_ids     = hash[:questions].map { |h| h[:id] }
    question_answers = hash[:questions].map { |h| h[:answer] }
    duration         = (hash[:end] - hash[:begin]).to_i
    player_ids       = hash[:players].map { |h| h[:id] }

    create!(
      quiz_id:          quiz_id,
      question_answers: Hash[question_ids.zip(question_answers)],
      question_ids:     question_ids,
      duration:         duration,
      interrupted:      question_answers.any?(&:nil?),
      first_player_id:  player_ids.first,
      second_player_id: player_ids.last,
    )
  end
end
