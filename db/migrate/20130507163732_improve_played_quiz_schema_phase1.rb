class ImprovePlayedQuizSchemaPhase1 < ActiveRecord::Migration
  class SchemaMigration < ActiveRecord::Base
  end

  def up
    execute "DELETE FROM schema_migrations WHERE schema_migrations.version = '20130421130148'"
    unless SchemaMigration.exists?(version: "20130428143023")
      change_table :played_quizzes do |t|
        t.integer :quiz_snapshot_id
        t.text :question_answers_array
        t.datetime :begin_time
        t.datetime :end_time
      end
    end
    change_table :played_quizzes do |t|
      t.string :students_order
      t.boolean :has_answers, default: true
    end
  end

  def down
    unless SchemaMigration.exists?(version: "20130428143023")
      raise ActiveRecord::IrreversibleMigration
    end
    change_table :played_quizzes do |t|
      t.remove :students_order
      t.remove :has_answers
    end
  end
end
