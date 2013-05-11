class CreateQuizSnapshots < ActiveRecord::Migration
  def change
    create_table :quiz_snapshots do |t|
      t.text :quiz_attributes
      t.text :questions_attributes
      t.datetime :created_at
    end
  end
end
