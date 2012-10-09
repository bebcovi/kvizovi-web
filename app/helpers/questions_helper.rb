# encoding: utf-8

module QuestionsHelper
  def categories
   [
     ["boolean",     'Točno/netočno'],
     ["choice",      'Ponuđeni odgovori'],
     ["association", 'Asocijacija'],
     ["image",       'Pogodi tko/što je na slici'],
     ["text",        'Upiši točan odgovor']
   ]
  end

  def number_of_fields(question)
    if question.choice? or question.association?
      current_page?(action: "new") ? 4 : question.data.count
    else
      raise ArgumentError, "The question is not a choice or association"
    end
  end

  def category_icon(category)
    case category
    when "boolean"     then icon("checkbox")
    when "choice"      then icon("list-view")
    when "association" then icon("shuffle")
    when "image"       then icon("picture")
    when "text"        then content_tag(:span, "Abc")
    end
  end
end
