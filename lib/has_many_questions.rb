module HasManyQuestions
  def has_many_questions(options = {})
    has_many :questions, options
    Question.categories.each do |category|
      has_many :"#{category}_questions", options
    end

    alias_method :all_questions, :questions
    define_method(:questions) do |category = nil|
      if category
        send(:"#{category}_questions")
      else
        all_questions
      end
    end
  end
end
