module QuestionsHelper
  def question_icons(category)
    hash = {
      "boolean"     => icon("checkbox"),
      "choice"      => icon("list-view"),
      "association" => icon("shuffle"),
      "image"       => icon("picture"),
      "text"        => icon("pencil-2"),
    }
    hash[category]
  end
end
