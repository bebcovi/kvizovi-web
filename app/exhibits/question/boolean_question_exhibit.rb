class BooleanQuestionExhibit < BaseExhibit
  def has_answer?(value)
    __getobj__.answer ==
      case value
      when String
        {"true" => true, "false" => false}[value]
      else
        value
      end
  end
end
