module School::QuestionsHelper
  def question_categories
    {
      "boolean"     => {label: "Točno/netočno",              icon_name: "checkbox"},
      "choice"      => {label: "Ponuđeni odgovori",          icon_name: "list-view"},
      "association" => {label: "Asocijacija",                icon_name: "shuffle"},
      "image"       => {label: "Pogodi tko/što je na slici", icon_name: "picture"},
      "text"        => {label: "Upiši točan odgovor",        icon_name: "pencil-2"},
    }
  end
end
