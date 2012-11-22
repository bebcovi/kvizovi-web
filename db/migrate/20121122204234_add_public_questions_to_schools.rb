class AddPublicQuestionsToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :public_questions, :boolean, default: true
  end
end
