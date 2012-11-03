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

    image_paths = []
    ImageQuestion.find_each do |question|
      data = ImageQuestionData.find(question.data_id)
      if data.image.exists?(:original)
        image_path = "#{Rails.root}/public/#{data.image.original_filename}"
        data.image.copy_to_local_file(:original, image_path)
        image_paths << image_path
      else
        image_paths << nil
      end
      data.send(:prepare_for_destroy)
      data.send(:destroy_attached_files)
    end

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
        image_path = image_paths.shift
        question.image = Rack::Test::UploadedFile.new(image_path, "image/jpeg") if image_path
        question.answer = data.answer
      when "text"
        question.answer = data.answer
      end

      data.destroy
      question.save!

      FileUtils.rm(image_path) if image_path
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
               image_path = "#{Rails.root}/public/#{question.image.original_filename}"
               question.image.copy_to_local_file(:original, image_path)
               question.send(:prepare_for_destroy)
               question.send(:destroy_attached_files)
               ImageQuestionData.create!(
                 image: Rack::Test::UploadedFile.new(image_path, "image/jpeg"),
                 answer: question.answer
               )
             when "text"
               TextQuestionData.create!(answer: question.answer)
             end

      question.update_column(:data_id, data.id)

      FileUtils.rm(image_path) if image_path
    end

    remove_column :questions, :data
  end
end
