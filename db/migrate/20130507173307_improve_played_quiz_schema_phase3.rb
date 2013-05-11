require "activerecord-postgres-hstore"

class ImprovePlayedQuizSchemaPhase3 < ActiveRecord::Migration
  class SchemaMigration < ActiveRecord::Base
  end

  def up
    unless SchemaMigration.exists?(version: "20130428143023")
      change_table :played_quizzes do |t|
        t.remove :question_answers
        t.rename :question_answers_array, :question_answers
        t.remove :first_player_id
        t.remove :second_player_id
        t.remove :interrupted
        t.remove :quiz_id
        t.remove :question_ids
        t.remove :duration
      end
    else
      execute "DELETE FROM schema_migrations WHERE schema_migrations.version = '20130428143023'"
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
