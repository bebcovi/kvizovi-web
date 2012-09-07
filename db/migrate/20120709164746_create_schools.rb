class CreateSchools < ActiveRecord::Migration
  def change
    create_table :schools do |t|
      t.string :name
      t.string :username
      t.string :password_digest
      t.string :level
      t.string :key

      t.timestamps
    end
  end
end
