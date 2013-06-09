class AddCategoryToQuizzes < ActiveRecord::Migration
  def change
    add_column :quizzes, :category, :string
  end
end
