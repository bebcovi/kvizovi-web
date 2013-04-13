class AssociationQuestionExhibit < BaseExhibit
  def associations
    result = __getobj__.associations.dup
    until result != __getobj__.associations
      left_side, right_side = result.keys.shuffle, result.values.shuffle
      result = Hash[left_side.zip(right_side)]
    end
    result
  end

  def has_answer?(value)
    case value
    when Array
      __getobj__.associations == Hash[*value]
    when Hash
      __getobj__.associations == value
    end
  end
end
