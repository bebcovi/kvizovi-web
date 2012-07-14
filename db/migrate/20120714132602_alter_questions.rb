class AlterQuestions < ActiveRecord::Migration
  def up
    remove_column :questions, :answers
    rename_column :questions, :correct_answer, :answer
    add_attachment :questions, :photo
  end

  def down
    add_column :questions, :answers, :text
    rename_column :questions, :answer, :correct_answer
    remove_attachment :questions, :photo
  end
end
