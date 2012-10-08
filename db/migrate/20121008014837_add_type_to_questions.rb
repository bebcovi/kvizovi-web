class AddTypeToQuestions < ActiveRecord::Migration
  def up
    remove_column :questions, :category
    add_column :questions, :type, :string
  end

  def down
    add_column :questions, :category, :string
    remove_column :questions, :type
  end
end
