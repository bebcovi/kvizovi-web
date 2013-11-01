module QuestionsHelpers
  def create_questions(number)
    number.times.map do |idx|
      FactoryGirl.create(:"#{Question::CATEGORIES[idx % 4]}_question")
    end
  end
end

World(QuestionsHelpers)
