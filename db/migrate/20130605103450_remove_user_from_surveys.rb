class RemoveUserFromSurveys < ActiveRecord::Migration
  def up
    remove_column :surveys, :user_id
    remove_column :surveys, :user_type
  end

  def down
    add_column :surveys, :user_type, :string
    add_column :surveys, :user_id, :integer
  end
end
