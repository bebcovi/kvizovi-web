class ChangeCorrectAnswerOnQuestions < ActiveRecord::Migration
  def change
    change_column :questions, :correct_answer, :text
  end
end
