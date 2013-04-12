class RemoveSchoolIdFromQuestions < ActiveRecord::Migration
  def up
    remove_column :questions, :school_id
  end

  def down
    add_column :questions, :school_id, :integer
  end
end
