require "activerecord-postgres-hstore"

class ImprovePlayedQuizSchemaPhase2 < ActiveRecord::Migration
  NO_ANSWER  = "NO_ANSWER"

  class SchemaMigration < ActiveRecord::Base
  end

  class QuizSnapshot < ActiveRecord::Base
    serialize :quiz_attributes
    serialize :questions_attributes

    def self.capture(quiz)
      if quiz
        create!(
          quiz_id:              quiz.id,
          quiz_attributes:      quiz.attributes,
        )
      end
    end
  end

  class Quiz < ActiveRecord::Base
    has_many :questions
  end

  class Student < ActiveRecord::Base
  end

  class PlayedQuiz < ActiveRecord::Base
    belongs_to :quiz
    belongs_to :quiz_snapshot
    has_and_belongs_to_many :students

    serialize :students_order
    serialize :question_answers_array
    serialize :question_answers, ActiveRecord::Coders::Hstore
  end

  def up
    unless SchemaMigration.exists?(version: "20130428143023")
      PlayedQuiz.find_each do |played_quiz|
        student_ids = [played_quiz.first_player_id, played_quiz.second_player_id].uniq
        quiz_snapshot = QuizSnapshot.capture(played_quiz.quiz)
        played_quiz.update_attributes!(
          quiz_snapshot: quiz_snapshot,
          question_answers_array: played_quiz.question_answers.values.map do |value|
            {"true" => true, "false" => false, "nil" => nil}[value]
          end,
          has_answers: false,
          end_time: played_quiz.created_at,
          begin_time: played_quiz.created_at - played_quiz.duration.seconds,
          students_order: student_ids,
        )
        student_ids.each do |student_id|
          execute "INSERT INTO played_quizzes_students (student_id, played_quiz_id) VALUES (#{student_id}, #{played_quiz.id})"
        end
      end
    end
  end

  def down
    unless SchemaMigration.exists?(version: "20130428143023")
      raise ActiveRecord::IrreversibleMigration
    end
  end
end
