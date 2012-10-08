class RenameAttachmentToImage < ActiveRecord::Migration
  def change
    remove_attachment :questions, :attachment
    add_attachment :questions, :image
  end
end
