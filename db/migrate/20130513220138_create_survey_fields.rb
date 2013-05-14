class CreateSurveyFields < ActiveRecord::Migration
  def change
    create_table :survey_fields do |t|
      t.string :question
      t.text :choices
      t.text :answer
      t.string :category
      t.integer :survey_id
    end
  end
end
