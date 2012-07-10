class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :content
      t.integer :type
      t.integer :correct_answer
      t.integer :points
      t.references :book

      t.timestamps
    end
    add_index :questions, :book_id
  end
end
