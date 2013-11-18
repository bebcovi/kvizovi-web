class AddIdToReadings < ActiveRecord::Migration
  def change
    add_column :readings, :id, :primary_key
  end
end
