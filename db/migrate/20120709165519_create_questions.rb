class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :content
      t.integer :category
      t.text :data
      t.integer :points
      t.references :quiz

      t.timestamps
    end
    add_attachment :questions, :attachment
  end
end
