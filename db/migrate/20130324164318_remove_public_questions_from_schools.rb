class RemovePublicQuestionsFromSchools < ActiveRecord::Migration
  def up
    remove_column :schools, :public_questions
  end

  def down
    add_column :schools, :public_questions, :boolean
  end
end
