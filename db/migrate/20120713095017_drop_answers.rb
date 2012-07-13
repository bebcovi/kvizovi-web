class DropAnswers < ActiveRecord::Migration
  def up
    drop_table :answers
  end

  def down
    create_table :answers do |t|
      t.string :content
      t.references :question

      t.timestamps
    end
    add_index :answers, :question_id
  end
end
