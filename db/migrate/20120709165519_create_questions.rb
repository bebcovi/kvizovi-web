class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :content
      t.integer :category
      t.text :data
      t.integer :points
      t.references :quiz
      t.references :book

      t.timestamps
    end
    add_index :questions, :book_id
    add_index :questions, :quiz_id
    add_attachment :questions, :attachment
  end
end
