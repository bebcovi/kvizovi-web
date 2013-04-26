class CreateQuizSnapshots < ActiveRecord::Migration
  def change
    create_table :quiz_snapshots do |t|
      t.text :quiz
      t.text :questions
      t.datetime :created_at
    end
  end
end
