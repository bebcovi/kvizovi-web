class AddQuizIdToQuizSnapshots < ActiveRecord::Migration
  def change
    add_column :quiz_snapshots, :quiz_id, :integer
  end
end
