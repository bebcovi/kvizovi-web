class AddIdToPlayings < ActiveRecord::Migration
  def change
    add_column :playings, :id, :primary_key
  end
end
