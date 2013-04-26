require "activerecord-postgres-hstore"

class PlayedQuiz < ActiveRecord::Base
  serialize :question_answers, ActiveRecord::Coders::Hstore
  serialize :question_ids, Array

  def self.build_from_hash(hash)
    quiz_id          = hash[:quiz][:id]
    question_ids     = hash[:questions].map { |h| h[:id] }
    question_answers = hash[:questions].map { |h| h[:answer] }
    duration         = (hash[:end] - hash[:begin]).to_i
    player_ids       = hash[:students].map { |h| h[:id] }

    new(
      quiz_id:          quiz_id,
      question_answers: Hash[question_ids.zip(question_answers)],
      question_ids:     question_ids,
      duration:         duration,
      interrupted:      question_answers.any?(&:nil?),
      first_player_id:  player_ids.first,
      second_player_id: player_ids.last,
    )
  end

  def self.create_from_hash(hash)
    record = build_from_hash(hash)
    record.save!
    record
  end

  def students
    Student.find(student_ids)
  end

  def quiz
    Quiz.find(quiz_id)
  end

  def questions
    question_answers.map do |_, answer|
      if answer.is_a?(String)
        {answer: {"true" => true, "false" => false, "nil" => nil}[answer]}
      else
        {answer: answer}
      end
    end
  end

  private

  def student_ids
    [first_player_id, second_player_id].uniq
  end
end
