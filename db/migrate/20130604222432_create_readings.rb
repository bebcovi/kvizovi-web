class CreateReadings < ActiveRecord::Migration
  def change
    create_table :readings, primary_key: false do |t|
      t.integer :user_id
      t.integer :user_type
      t.integer :post_id
    end
  end
end
