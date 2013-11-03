class RemoveCategoryFromQuizzes < ActiveRecord::Migration
  def change
    remove_column :quizzes, :category, :string
  end
end
