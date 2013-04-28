class ImprovePlayedQuizSchemaWithQuizSnapshot < ActiveRecord::Migration
  def up
    change_table :played_quizzes do |t|
      t.remove(:quiz_id); t.integer(:quiz_snapshot_id)
      t.remove(:question_answers); t.text(:question_answers)
      t.remove(:question_ids)
      t.remove(:duration); t.datetime(:begin_time); t.datetime(:end_time)
      t.remove(:interrupted)
      t.remove(:first_player_id); t.remove(:second_player_id); t.string(:student_ids)
    end
  end

  def down
    change_table :played_quizzes do |t|
      t.integer(:quiz_id); t.remove(:quiz_snapshot_id)
      t.text(:question_ids)
      t.integer(:duration); t.remove(:begin_time); t.remove(:end_time)
      t.boolean(:interrupted)
      t.integer(:first_player_id); t.integer(:second_player_id); t.remove(:student_ids)
    end
  end
end
