class DeleteCreateQuizQuestionsJoinTable < ActiveRecord::Migration
  def up
    remove_column :questions, :quiz_id
  end

  def down
    add_column :questions, :quiz_id, :integer
  end
end
