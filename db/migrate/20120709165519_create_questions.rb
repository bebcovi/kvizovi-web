class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.text :content
      t.string :category
      t.text :data
      t.integer :points, default: 1
      t.references :quiz

      t.timestamps
    end
    add_attachment :questions, :attachment
  end
end
