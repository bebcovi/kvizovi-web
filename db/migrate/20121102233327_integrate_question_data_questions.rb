class BooleanQuestionData < ActiveRecord::Base
end
class ChoiceQuestionData < ActiveRecord::Base
  serialize :provided_answers, Array
end
class AssociationQuestionData < ActiveRecord::Base
  serialize :associations, Hash
end
class TextQuestionData < ActiveRecord::Base
end
class ImageQuestionData < ActiveRecord::Base
  has_attached_file :image, styles: {resized: "x250>"},
    dropbox_options: { path: ->(style) { "lektire/#{id}_#{image.original_filename}" } }
end

class IntegrateQuestionDataQuestions < ActiveRecord::Migration
  def up
    add_column :questions, :data, :text, default: {}

    Question.find_each do |question|
      data_class = "#{question.category.capitalize}QuestionData".constantize
      data = data_class.find(question.data_id)

      case question.category
      when "boolean"
        question.answer = data.answer
      when "choice"
        question.provided_answers = data.provided_answers
      when "association"
        question.associations = data.associations
      when "image"
        question.answer = data.answer
      when "text"
        question.answer = data.answer
      end

      data.destroy
      question.save(validate: false)
    end

    remove_column :questions, :data_id
    drop_table :association_question_data
    drop_table :boolean_question_data
    drop_table :choice_question_data
    drop_table :image_question_data
    drop_table :text_question_data
  end

  def down
    add_column :questions, :data_id, :integer

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

    Question.find_each do |question|
      data = case question.category
             when "boolean"
               BooleanQuestionData.create!(answer: question.answer)
             when "choice"
               ChoiceQuestionData.create!(provided_answers: Array(question.provided_answers))
             when "association"
               AssociationQuestionData.create!(associations: Hash[question.associations])
             when "image"
               ImageQuestionData.create!(answer: question.answer)
             when "text"
               TextQuestionData.create!(answer: question.answer)
             end

      question.update_column(:data_id, data.id)
      question.send(:prepare_for_destroy)
      question.send(:destroy_attached_files)
    end

    remove_column :questions, :data
  end
end
