class ChangeContentOnQuestions < ActiveRecord::Migration
  def up
    change_column :questions, :content, :text
  end

  def down
    change_column :questions, :content, :string
  end
end
