# encoding: utf-8

module QuestionsHelper
  def categories
    {
      boolean:     ["Točno/netočno",              icon("checkbox")],
      choice:      ["Ponuđeni odgovori",          icon("list-view")],
      association: ["Asocijacija",                icon("shuffle")],
      image:       ["Pogodi tko/što je na slici", icon("picture")],
      text:        ["Upiši točan odgovor",        content_tag(:span, "Abc")]
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
end
