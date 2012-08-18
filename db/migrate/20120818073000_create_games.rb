class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.text :info
      t.references :quiz

      t.timestamps
    end
  end
end
