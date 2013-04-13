require_relative "question/association_question_exhibit"
require_relative "question/choice_question_exhibit"
require_relative "question/text_question_exhibit"
require_relative "question/image_question_exhibit"
require_relative "question/boolean_question_exhibit"

class QuestionExhibit
  def self.new(question)
    "#{question.class.name}Exhibit".constantize.new(question)
  end
end
