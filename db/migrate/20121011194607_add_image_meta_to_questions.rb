class AddImageMetaToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :image_meta, :string
  end
end
