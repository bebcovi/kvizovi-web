module QuestionsHelper
  def question_icons(category)
    hash = {
      "boolean"     => icon("checkbox"),
      "choice"      => icon("list"),
      "association" => icon("shuffle"),
      "text"        => icon("pencil"),
    }
    hash[category]
  end

  def number_of_fields(collection)
    collection.any? ? collection.count : 4
  end
end
