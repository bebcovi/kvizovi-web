class CreateEras < ActiveRecord::Migration
  def change
    create_table :eras do |t|
      t.string :name
      t.integer :start_year
      t.integer :end_year
      t.references :school

      t.timestamps
    end
    add_index :eras, :school_id
  end
end
