class ImproveQuestionsSchema < ActiveRecord::Migration
  def up
    create_table :questions, force: true do |t|
      t.text :content
      t.string :hint
      t.references :data
      t.references :quiz

      t.string :type

      t.timestamps
    end

    create_table :boolean_question_data do |t|
      t.boolean :answer
    end

    create_table :choice_question_data do |t|
      t.text :provided_answers
    end

    create_table :association_question_data do |t|
      t.text :associations
    end

    create_table :text_question_data do |t|
      t.string :answer
    end

    create_table :image_question_data do |t|
      t.attachment :image
      t.string :image_meta
      t.string :answer
    end
  end

  def down
    create_table :questions, force: true do |t|
      t.text       :content
      t.text       :data
      t.text       :hint
      t.attachment :image
      t.string     :image_meta
      t.string     :type

      t.references :quiz
      t.timestamps
    end

    drop_table :boolean_question_data
    drop_table :choice_question_data
    drop_table :association_question_data
    drop_table :text_question_data
    drop_table :image_question_data
  end
end
