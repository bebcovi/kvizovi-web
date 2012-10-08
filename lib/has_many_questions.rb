require_relative "../app/models/question"

module HasManyQuestions
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def has_many_questions(options = {})
      has_many :general_questions, options.merge({class_name: "Question"})
      Question.categories.each do |category|
        has_many "#{category}_questions", options
      end
    end
  end

  def questions(category = nil)
    if category
      send("#{category}_questions")
    else
      general_questions
    end
  end
end
