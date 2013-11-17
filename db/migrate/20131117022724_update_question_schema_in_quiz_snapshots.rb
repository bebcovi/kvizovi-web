class UpdateQuestionSchemaInQuizSnapshots < ActiveRecord::Migration
  class QuizSnapshot < ActiveRecord::Base
    serialize :questions_attributes
  end

  class Question < ActiveRecord::Base
  end

  def change
    QuizSnapshot.all.each do |quiz_snapshot|
      next if quiz_snapshot.questions_attributes.nil?
      quiz_snapshot.questions_attributes.each do |attributes|
        if attributes["type"] == "ImageQuestion"
          begin
            question = Question.find(attributes["id"])
            attributes.update("image" => question["image"])
          rescue ActiveRecord::RecordNotFound
          end
        end
      end
    end
    QuizSnapshot.update_all("questions_attributes = replace(questions_attributes, 'ImageQuestion', 'TextQuestion')")
  end
end
