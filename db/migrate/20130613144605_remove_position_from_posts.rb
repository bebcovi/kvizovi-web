class RemovePositionFromPosts < ActiveRecord::Migration
  def change
    remove_column :posts, :position, :integer
  end
end
