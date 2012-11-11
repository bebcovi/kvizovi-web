# encoding: utf-8

module QuestionsHelper
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
    if question.choice?
      current_page?(action: "new") ? 4 : question.provided_answers.count
    elsif question.association?
      current_page?(action: "new") ? 4 : question.associations.count
    else
      raise ArgumentError, "The question is not a choice or association"
    end
  end

  def answer_title
    %(<ul><li>"Matoš" = "matoš"</li><li>"Matoš" = "Matoš."</li><li>"Matoš" ≠ "Matos"</li>)
  end

  def tag_filter
    simple_form_for Filter.new(params[:filter]), url: request.path, method: "get" do |f|
      f.input(:tags) +
      buttons(f) do |b|
        b.button_button("Filtrirajte", name: nil) +
        b.cancel_button("Očistite filter", request.path)
      end
    end
  end
end

class Filter
  include ActiveAttr::Model

  attribute :tags, type: String
end
