class AssignsPositionsToQuestions < ActiveRecord::Migration
  class Quiz < ActiveRecord::Base
    has_many :questions
  end

  class Question < ActiveRecord::Base
    belongs_to :quiz
  end

  class BooleanQuestion     < Question;     end
  class AssociationQuestion < Question;     end
  class ChoiceQuestion      < Question;     end
  class TextQuestion        < Question;     end
  class ImageQuestion       < TextQuestion; end

  def up
    handle_single_table_inheritance(Question) do
      Quiz.find_each do |quiz|
        position = 0
        quiz.questions.order("created_at ASC").each do |question|
          position += 1
          question.update_attributes(position: position)
        end
      end
    end
  end

  def down
  end
end
