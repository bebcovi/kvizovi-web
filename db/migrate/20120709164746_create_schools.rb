class CreateSchools < ActiveRecord::Migration
  def change
    create_table :schools do |t|
      t.string :name
      t.string :slug
      t.string :username
      t.string :password_digest
      t.integer :level, limit: 1
      t.string :key

      t.timestamps
    end
  end
end
