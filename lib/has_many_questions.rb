require_relative "../app/models/question"

module HasManyQuestions
  def has_many_questions(options = {})
    has_many :questions, options
    Question.categories.each do |category|
      has_many "#{category}_questions", options
    end

    alias_method :general_questions, :questions
    include InstanceMethods
  end

  module InstanceMethods
    def questions(category = nil)
      if category
        send("#{category}_questions")
      else
        general_questions
      end
    end
  end
end
