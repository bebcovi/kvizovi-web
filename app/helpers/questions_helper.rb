# encoding: utf-8

module QuestionsHelper
  def categories
   [
     ["boolean", 'Točno/netočno'],
     ["choice", '4 ponuđena odgovora'],
     ["association", 'Asocijacija'],
     ["photo", 'Pogodi tko/što je na slici'],
     ["text", 'Upiši točan odgovor']
   ]
  end
end
