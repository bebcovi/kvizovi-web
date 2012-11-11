require_relative "../app/models/question"

module HasManyQuestions
  [:has_many, :has_and_belongs_to_many].each do |association_name|
    define_method("#{association_name}_questions") do |options = {}|
      send(association_name, :questions, options)
      Question.categories.each do |category|
        send(association_name, :"#{category}_questions", options.except(:dependent))
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
end
