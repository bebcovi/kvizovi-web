# encoding: utf-8

module QuestionsHelper
  def categories
   [
     ["boolean",     'Točno/netočno'],
     ["choice",      'Ponuđeni odgovori'],
     ["association", 'Asocijacija'],
     ["photo",       'Pogodi tko/što je na slici'],
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
end
