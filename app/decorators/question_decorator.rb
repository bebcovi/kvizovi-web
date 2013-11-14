class QuestionDecorator < Draper::Decorator
  delegate_all

  def icon
    case category
    when "boolean"     then h.icon("checkbox")
    when "choice"      then h.icon("list")
    when "association" then h.icon("shuffle")
    when "text"        then h.icon("pencil")
    end
  end
end
