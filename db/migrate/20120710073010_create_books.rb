class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.references :school
      t.references :era

      t.timestamps
    end
    add_index :books, :school_id
    add_index :books, :era_id
  end
end
