class QuizDecorator < Draper::Decorator
  delegate_all

  def time_per_question
    case object.time
    when 1 then "15 sekundi po pitanju"
    when 2 then "30 sekundi po pitanju"
    when 3 then "45 sekundi po pitanju"
    when 4 then "60 sekundi po pitanju"
    when 5 then "neograničeno vrijeme"
    end
  end
end
