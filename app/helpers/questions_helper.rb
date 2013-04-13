module QuestionsHelper
  def question_icons(category)
    hash = {
      "boolean"     => icon("checkbox"),
      "choice"      => icon("list"),
      "association" => icon("shuffle"),
      "image"       => icon("image"),
      "text"        => icon("pencil"),
    }
    hash[category]
  end
end
