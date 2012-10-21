class AlterGames < ActiveRecord::Migration
  def up
    create_table :games, force: true do |t|
      t.integer  :quiz_id
      t.hstore   :question_answers
      t.text     :question_ids
      t.integer  :duration
      t.boolean  :interrupted
      t.integer  :first_player_id
      t.integer  :second_player_id

      t.datetime :created_at
    end
  end

  def down
    create_table :games, force: true do |t|
      t.text       :info
      t.references :quiz

      t.timestamps
    end
  end
end
