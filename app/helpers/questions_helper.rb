module QuestionsHelper
  def number_of_fields(collection)
    collection.any? ? collection.count : 4
  end
end
