module School::QuestionsHelper
  def categories
    {
      boolean:     ["Točno/netočno",              icon("checkbox")],
      choice:      ["Ponuđeni odgovori",          icon("list-view")],
      association: ["Asocijacija",                icon("shuffle")],
      image:       ["Pogodi tko/što je na slici", icon("picture")],
      text:        ["Upiši točan odgovor",        icon("pencil-2")]
    }
  end

  def number_of_fields(question)
    case question.category
    when "choice"
      current_page?(action: "new") ? 4 : question.provided_answers.count
    when "association"
      current_page?(action: "new") ? 4 : question.associations.count
    else
      raise ArgumentError, "The question is not a choice or association"
    end
  end

  def answer_title
    content_tag :ul do
      list_of [
        %("Matoš" = "matoš"),
        %("Matoš" = "Matoš."),
        %("Matoš" ≠ "Matos")
      ] { |item| concat(item) }
    end
  end
end

class Filter
  include ActiveAttr::Model

  attribute :tags, type: String
end
